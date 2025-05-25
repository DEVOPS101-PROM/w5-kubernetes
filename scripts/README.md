# Kubernetes Resource Top Plugin (kubectl-resource-top)

Скрипт kubeplugin.sh (призначений для використання як kubectl-resource-top) — це утиліта командного рядка, написана на Bash, для отримання та відображення статистики використання ресурсів (CPU та Memory) для подів (pods) та вузлів (nodes) у кластері Kubernetes. Він використовує команду kubectl top для збору даних і може бути інтегрований як плагін kubectl.

## Можливості

* Отримання метрик CPU та Memory для подів та вузлів.
* Запит даних для конкретного простору імен (namespace) або для всіх просторів імен (all).
* Два формати виводу:
  * csv: Дані у форматі Comma-Separated Values, зручному для подальшої обробки скриптами або імпорту в таблиці.
  * console: Табличний, людиночитабельний формат для швидкого перегляду в консолі (формат за замовчуванням).
* Налаштовуваний режим налагодження (DEBUG_MODE) для детального логування.

## Передумови

* Встановлений kubectl та налаштований доступ до вашого кластера Kubernetes.
* Metrics Server повинен бути встановлений у вашому кластері Kubernetes, оскільки kubectl top залежить від нього.
* Оболонка Bash.

## Встановлення як плагіна kubectl

Щоб використовувати цей скрипт як плагін kubectl (наприклад, щоб викликати його як kubectl resource-top), виконайте такі кроки:

1. Збережіть скрипт:
Збережіть вміст скрипта у файл. Рекомендована назва для плагіна kubectl повинна починатися з kubectl-. Наприклад, збережіть його як kubectl-resource-top.
 # Наприклад, ви завантажили або скопіювали скрипт у файл kubeplugin.sh # Перейменуйте його для використання як плагін: mv kubeplugin.sh kubectl-resource-top 

2. Надайте права на виконання:
Зробіть файл виконуваним:
 chmod +x kubectl-resource-top 

3. Розмістіть у PATH:
Перемістіть виконуваний файл kubectl-resource-top до каталогу, який є у вашій системній змінній PATH. kubectl автоматично виявляє плагіни, що знаходяться в PATH і мають префікс kubectl-.
Популярні місця для користувацьких скриптів: /usr/local/bin, /bin (якщо цей каталог створений та доданий до PATH).
 # Приклад переміщення до /usr/local/bin: sudo mv kubectl-resource-top /usr/local/bin/ 
Після цього ви зможете викликати плагін як kubectl resource-top.

4. Перевірка (опціонально):
Ви можете перевірити, чи kubectl бачить ваш плагін:
 kubectl plugin list 
Ви повинні побачити щось на зразок:
 The following kubectl-compatible plugins are available: /usr/local/bin/kubectl-resource-top 

## Використання

Після встановлення як плагіна, загальний синтаксис команди:
 kubectl resource-top [-f <format>] [namespace_or_all_for_pods] <resource_type> 

Аргументи:

* -f <format> (опціонально): Вказує формат виводу.
  * csv: Вивід у форматі CSV.
  * console: Вивід у табличному форматі для консолі (за замовчуванням).
* [namespace_or_all_for_pods]:
  * Для pods: Вкажіть простір імен Kubernetes (наприклад, default) або all. Це ОБОВ'ЯЗКОВО.
  * Для nodes: Цей аргумент є опціональним. Якщо надано, він ігнорується при виконанні команди, оскільки метрики вузлів є загальнокластерними.
* <resource_type>: Тип ресурсу для запиту. Підтримуються:
  * pods (або pod)
  * nodes (або node)

### Приклади

1. Отримати використання ресурсів для всіх подів у просторі імен default (формат консолі за замовчуванням):
 kubectl resource-top default pods 

2. Отримати використання ресурсів для всіх подів у просторі імен default у форматі CSV:
 kubectl resource-top -f csv default pods 

3. Отримати використання ресурсів для всіх подів у всіх просторах імен (формат консолі):
 kubectl resource-top -f console all pods 
Або просто:
 kubectl resource-top all pods 

4. Отримати використання ресурсів для всіх вузлів кластера (формат консолі):
 kubectl resource-top nodes 
Або, якщо ви звикли вказувати простір імен, хоча він ігнорується для вузлів:
 kubectl resource-top -f console default nodes 

5. Отримати використання ресурсів для вузлів у форматі CSV:
 kubectl resource-top -f csv nodes 

### Приклад виводу (формат console)

Для вузлів (kubectl resource-top nodes):
 TYPE       | NAMESPACE                 | NAME                                     | CPU        | MEMORY -----------|---------------------------|------------------------------------------|------------|------------ nodes      | <cluster>                 | k3d-k3s-default-server-0                 | 71m        | 729Mi 

Для подів (kubectl resource-top all pods):
 TYPE       | NAMESPACE                 | NAME                                     | CPU        | MEMORY -----------|---------------------------|------------------------------------------|------------|------------ pods       | default                   | nginx-676b6c5bbc-2czkk                   | 0m         | 12Mi pods       | kube-system               | coredns-ccb96694c-gjz48                  | 3m         | 19Mi pods       | kube-system               | local-path-provisioner-5cf85fd84d-xqtvc  | 1m         | 8Mi pods       | kube-system               | metrics-server-5985cbc9d7-jzd7j          | 5m         | 27Mi pods       | kube-system               | svclb-traefik-e21c9026-hgdf5             | 0m         | 0Mi pods       | kube-system               | traefik-5d45fc8cc9-5ctm8                 | 2m         | 42Mi 

### Приклад виводу (формат csv)

 ResourceType,Namespace,Name,CPU,Memory nodes,<cluster>,k3d-k3s-default-server-0,71m,729Mi 
 ResourceType,Namespace,Name,CPU,Memory pods,default,nginx-676b6c5bbc-2czkk,0m,12Mi pods,kube-system,coredns-ccb96694c-gjz48,3m,19Mi pods,kube-system,local-path-provisioner-5cf85fd84d-xqtvc,1m,8Mi pods,kube-system,metrics-server-5985cbc9d7-jzd7j,5m,27Mi pods,kube-system,svclb-traefik-e21c9026-hgdf5,0m,0Mi pods,kube-system,traefik-5d45fc8cc9-5ctm8,2m,42Mi 

## Налагодження

Щоб увімкнути режим налагодження для отримання більш детальної інформації про виконання скрипту (якщо ви запускаєте його безпосередньо, а не через kubectl), відредагуйте файл скрипта (kubectl-resource-top) та змініть значення змінної:
bash DEBUG_MODE="false" 
на
 DEBUG_MODE="true" 
Повідомлення налагодження будуть виводитися у стандартний потік помилок (stderr). При запуску через kubectl resource-top цей режим може не мати очікуваного ефекту безпосередньо в консолі, оскільки kubectl керує потоками виводу.