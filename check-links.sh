#!/usr/bin/env bash
erro=0
urls=$(grep -ohE '(href|src)="[^"]*"' *.html | sed -E 's/^(href|src)="//; s/"$//')

for url in $urls; do
  case "$url" in
    ""|\#*|mailto:*|tel:*) continue ;;
    http://*|https://*)
      code=$(curl -s -o /dev/null -L -m 15 -A "Mozilla/5.0" -w "%{http_code}" "$url")
      
      if [ "$code" != "999" ] && { [ "$code" -ge 400 ] || [ "$code" -eq 0 ]; }; then
        echo "::error::URL inválida ($code): $url"
        erro=1
      fi ;;
    *)
      if [ ! -e "${url%%[?#]*}" ]; then
        echo "::error::Caminho inexistente: $url"
        erro=1
      fi ;;
  esac
done

exit $erro