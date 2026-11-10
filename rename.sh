#!/usr/bin/env bash
# Запускать из корня репозитория (папка, где лежит CMakeLists.txt).
# Заменяет все упоминания Jopa на Vlad Saveljev Launcher: в тексте файлов и в именах файлов.
set -e
[ -f CMakeLists.txt ] || { echo "Запусти из корня репозитория (рядом с CMakeLists.txt)"; exit 1; }

# Порядок важен: сначала самые длинные строки.
replace_all() {
  grep -rIl -i "jopa" . --exclude-dir=.git --exclude-dir=build --exclude=rename.sh | while read -r f; do
    sed -i \
      -e 's/io\.github\.jopalauncher\.JopaLauncher/io.github.wijeddd.VladSaveljevLauncher/gI' \
      -e 's/jopa-launcher/vlad-saveljev-launcher/gI' \
      -e 's/Jopa Launcher/Vlad Saveljev Launcher/gI' \
      -e 's/JopaLauncher/VladSaveljevLauncher/g' \
      -e 's/jopalauncher/vladsaveljevlauncher/g' \
      -e 's/JOPALAUNCHER/VLADSAVELJEVLAUNCHER/g' \
      -e 's/JOPA/VLADSAVELJEV/g' \
      "$f"
  done
}
replace_all

# Переименование файлов и папок (сначала самые глубокие)
find . -path ./.git -prune -o -depth -iname '*jopa*' -print | while read -r p; do
  d=$(dirname "$p"); b=$(basename "$p")
  nb=$(echo "$b" | sed \
    -e 's/io\.github\.jopalauncher\.JopaLauncher/io.github.wijeddd.VladSaveljevLauncher/I' \
    -e 's/JopaLauncher/VladSaveljevLauncher/' \
    -e 's/jopalauncher/vladsaveljevlauncher/I' \
    -e 's/jopa-launcher/vlad-saveljev-launcher/I')
  [ "$b" != "$nb" ] && mv "$p" "$d/$nb" && echo "rename: $p -> $d/$nb"
done

echo "--- Осталось упоминаний jopa (должно быть пусто):"
grep -rIn -i "jopa" . --exclude-dir=.git --exclude=rename.sh || echo "нет"
find . -path ./.git -prune -o -iname '*jopa*' -print
