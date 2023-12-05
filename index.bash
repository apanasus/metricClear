#!/bin/bash
# сначала установить: sudo apt-get install inotify-tools
# путь до папки с лендами 
directory_to_watch="/полный/путь/к/директории"

# Запускаем бесконечный цикл
while true; do
    # Ожидаем событие создания каталога в директории
    event=$(inotifywait -r -e create --format '%w%f' "$directory_to_watch") 
    # Ищем файлы с расширением .html и .php, содержащие "googletagmanager"
    files=$(grep -rl -e "googletagmanager" -e "google-site-verification" -e "googletagmanager" "$event"/*.html "$event"/*.php)

    # Проверяем, найдены ли файлы
    if [ -n "$files" ]; then 
        sed -i '/<meta.*name="google-site-verification".*\/>/d' $files
        sed -i '/<noscript.*googletagmanager.*<\/noscript>/d' $files
        sed -i '/<script/,/<\/script>/ {/<script.*googletagmanager.*<\/script>/d}' $files
        echo "Блоки кода и теги <meta> удалены."
    else
        echo "Файлы, содержащие 'googletagmanager', не найдены."
    fi
done
