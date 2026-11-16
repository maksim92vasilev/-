#!/usr/bin/env bash
# create_conflict.sh
# Скрипт имитирует работу двух разработчиков: Алиса и Боб изменяют
# одну и ту же строку README.md в разных ветках, чтобы при слиянии
# получить искусственный конфликт.

set -e

# Проверяем, что мы внутри Git-репозитория
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Ошибка: запустите скрипт внутри Git-репозитория (сначала выполните git init)."
    exit 1
fi

# Если базовый коммит ещё не сделан — делаем его
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    git add README.md
    git commit -m "init: базовый README"
fi

# Создаём ветки, если их ещё нет
git branch feature-alice 2>/dev/null || true
git branch feature-bob  2>/dev/null || true

# --- Ветка Алисы: правит строку описания ---
git checkout feature-alice
sed -i.bak 's/Проект: тренировка слияния веток и разрешения конфликтов/Проект: версия Алисы (описание функционала)/' README.md
rm -f README.md.bak
git add README.md
git commit -m "feat: Алиса добавила описание функционала в README"

# --- Ветка Боба: правит ту же строку по-своему ---
git checkout feature-bob
sed -i.bak 's/Проект: тренировка слияния веток и разрешения конфликтов/Проект: версия Боба (инструкция по установке)/' README.md
rm -f README.md.bak
git add README.md
git commit -m "docs: Боб добавил инструкцию по установке в README"

# --- Возвращаемся на main ---
git checkout main

echo ""
echo "Готово! Ветки созданы, одна строка изменена двумя 'разработчиками'."
echo "Теперь выполните слияние и получите конфликт:"
echo ""
echo "  git merge feature-alice   # пройдёт без конфликта"
echo "  git merge feature-bob     # здесь возникнет конфликт"
echo ""
echo "Откройте README.md, разрешите конфликт, затем:"
echo "  git add README.md && git commit"
