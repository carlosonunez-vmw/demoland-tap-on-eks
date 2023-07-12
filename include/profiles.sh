# vi: set ft=sh:
# The reference architecture asks for four clusters: build, run, iterate, and view.
# The view cluster requires 8 CPUs whereas the build/run/iterate clusters require 12 CPUs each.
# Since deploying the ref arch requires 44 CPUs total (!!!), we'll try to deploy just the full
# profile if we're under that or deploy the entire refarch otherwise.
MIN_CPU_FOR_ENTIRE_REF_ARCH=44
REF_ARCH_CLUSTERS=(build run view iterate)
NON_REF_ARCH_CLUSTERS=(full)

cpus() {
  case "$(uname)" in
    Darwin)
      sysctl hw.ncpu | awk -F':' '{print $NF}'
      ;;
    Linux)
      grep -cE 'processor' /cpu/procinfo
      ;;
    *)
      >&2 echo "ERROR: Unable to determine number of CPUs."
      exit 1
      ;;
  esac
}

profiles_to_install() {
  cpus=$(cpus) || return 1
  if test "$cpus" -ge "$MIN_CPU_FOR_ENTIRE_REF_ARCH"
  then echo "${REF_ARCH_CLUSTERS[@]}"
  else echo "${NON_REF_ARCH_CLUSTERS[@]}"
  fi
}
