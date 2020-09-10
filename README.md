# How to use?
- Setup: `docker-compose up -d --build`
- Interact: `docker-compose run --rm app %command%`

# Performance
If you're using this solution with WSL2 you must place repository files inside WSL virtual machine, otherwise Nginx is very slow!

# What's inside?
- PHP 7.3
- Composer
- NodeJS 12 and NPM
- Nginx
- MySQL 5.7
