// server.c -- A simple socket stream demo
// Shamelessly ripped from Beej's Networking Guide:
// https://beej.us/guide/bgnet/html/#client-server-background

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <signal.h>

int MAX_CONNECTIONS = 10; // Max connections we'll hold before refusing
char * PORT = "1234";
char * HELLO_MESSAGE = "Hello from the Tanzu Application Platform!";
int stop_server = 0;

void signal_callback_handler(int signal)
{
  int saved_errno = errno;
  while (waitpid(-1, NULL, WNOHANG) > 0);
  errno = saved_errno;
}

void signal_sigint_handler(int signal)
{
  puts("server: received interrupt; exiting (connect again if server does not quit)");
  stop_server = 1;
}

void *get_inet_address(struct sockaddr *sa)
{
  // AF_INET == IPv4
  if (sa->sa_family == AF_INET) {
    return &(((struct sockaddr_in*)sa)->sin_addr);
  }
  return &(((struct sockaddr_in6*)sa)->sin6_addr);

}

int main(void)
{
  int sockfd, new_fd;
  struct addrinfo hints, *servinfo, *p;
  struct sockaddr_storage client_addr;
  socklen_t sin_size;
  struct sigaction sa, si;
  int yes=1;
  char s[INET6_ADDRSTRLEN];
  int rv;

  // Get interfaces that are capable of listening to inbound
  // requests. AI_PASSIVE indicates that we want to listen
  // on all interfaces.
  memset(&hints, 0, sizeof hints);
  hints.ai_family = AF_UNSPEC;
  hints.ai_socktype = SOCK_STREAM;
  hints.ai_flags = AI_PASSIVE; // wildcard IP, i.e. 0.0.0.0
  if ((rv = getaddrinfo(NULL, PORT, &hints, &servinfo)) != 0) {
    fprintf(stderr, "getaddrinfo: %s\n", gai_strerror(rv));
    return 1;
  }

  // Try to connect to the first available interface that responded
  // to getaddrinfo(4).
  for (p = servinfo; p != NULL; p = p->ai_next) {
    if ((sockfd = socket(p->ai_family,
            p->ai_socktype,
            p->ai_protocol)) == -1) {
      perror("server: socket");
      continue;
    }
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &yes,
          sizeof(int)) == -1) {
      perror("setsockopt");
      exit(1);
    }
    if (bind(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
      close(sockfd);
      perror("server: bind");
      continue;
    }
    break;
  }

  // yay, manual memory management!
  freeaddrinfo(servinfo);
  if (p == NULL) {
    fprintf(stderr, "server: failed to bind\n");
    exit(1);
  }

  // Start listening for connections
  if (listen(sockfd, MAX_CONNECTIONS) == -1) {
    perror("listen");
    exit(1);
  }

  // Register a handler to handle the child process exiting
  // (which will trip SIGCHLD)
  sa.sa_handler = signal_callback_handler;
  sigemptyset(&sa.sa_mask);
  sa.sa_flags = SA_RESTART;
  if (sigaction(SIGCHLD, &sa, NULL) == -1) {
    perror("sigaction");
    exit(1);
  }
  si.sa_handler = signal_sigint_handler;
  sigemptyset(&si.sa_mask);
  sigaction(SIGINT, &si, NULL);

  // Listen for new connections and "hello world" them on
  // TCP ESTABLISHED.
  puts("server: Listening...\n");
  while(1) {
    if (stop_server == 1) {
      return 0;
    }
    sin_size = sizeof client_addr;
    new_fd = accept(sockfd, (struct sockaddr *)&client_addr, &sin_size);
    if (new_fd == -1) {
      perror("accept");
      continue;
    }
    inet_ntop(client_addr.ss_family,
        get_inet_address((struct sockaddr *)&client_addr),
        s, sizeof s);
    printf("server: hello there! you are: %s\n", s);
    if (!fork()) {
      close(sockfd);
      char msg[strlen(HELLO_MESSAGE)+2];
      strcpy(msg, HELLO_MESSAGE);
      strcat(msg, "\n\0");
      if (send(new_fd, &msg, strlen(msg), 0) == -1)
        perror("send");
      close(new_fd);
      exit(0);
    }
    close(new_fd);
  }

  // SIGINT/SIGKILL received; stop the server.
  puts("server: received stop signal; terminating.\n");
  return 0;
}
