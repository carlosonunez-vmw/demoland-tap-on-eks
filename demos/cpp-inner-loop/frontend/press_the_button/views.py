from django.http import HttpResponse
from django.shortcuts import render
from django.conf import settings
from django.urls import reverse
import socket
import logging

def check_backend(request):
    logger = logging.getLogger(__name__)
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(3)
    resp = ""
    try:
        s.connect((settings.BACKEND_HOST, int(settings.BACKEND_PORT)))
        while True:
            chunk = s.recv(1024)
            if (len(chunk) < 1):
                break
            resp = resp + chunk.decode("utf-8")
        return HttpResponse(resp, status=200)
    except Exception as e:
        logger.error(f"Service unavailable at {settings.BACKEND_HOST}:{settings.BACKEND_PORT}: {e}")
        return HttpResponse(status=503)

    

def index(request):
    context = {
            "title": "Backend Check",
            "backendURL": reverse("check_backend"),
    }
    return render(request, "index.html", context)
