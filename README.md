# Challenge 4 - Colibri

<details open="open">
  <summary>Sommaire</summary>
  <ol>
    <li>
      <a href="#description">Description du projet</a>
    </li>
    <li>
      <a href="#installation">Installation</a>
      <ul>
        <li><a href="#golang-backend">GoLang - Backend</a></li>
        <li><a href="#flutter-frontend">Frontend - Flutter</a></li>
      </ul>
    </li>
    <li><a href="#membres-du-groupe">Membres du groupe</a></li>
    <li><a href="#listes-des-features">Listes des features</a></li>
    <li><a href="#demo">DEMO</a></li>
  </ol>
</details>

## Description
Pour permettre de vivre en harmonie avec ces colocataires, notre applications permettra de gérer la gestion des tâches et la répartition pour faire participer tout le monde à la vie commune.

## Installation 

Il faut cloner le projet pour pouvoir le lancer.

```sh
git clone git@github.com:NhiSty/Colibris.git
```
- Assurez vous d'avoir docker d'allumé

### GoLang-Backend
- Allez dans le dossier `Back` avec la commande : 
```sh
cd Back
```

- Copier le fichier `.env.example` et le renommer en `.env`

- Pour exécuter le projet, lancer la commande : 
```sh
docker-compose up -d
``` 
- Pour voir les logs, lancer la commande : 
```sh
docker logs -f golang
```

- **(OPTIONNEL)** Si vous avez besoin de recharger le container, lancer la commande : 
```sh
docker compose restart golang
```
- Pour accéder au swagger, ouvrez votre navigateur et allez à l'adresse : 
```sh
http://localhost:8080/api/v1/swagger/index.html
```

### Flutter-Frontend
- Allez dans le dossier `Front` avec la commande : 
```sh
cd Front
```

- Copier le fichier `.env.example` et le renommer en `.env`

- Pour exécuter le projet en mobile, lancer la commande : 
```sh
flutter run
```

- Pour exécuter le projet en web, lancer la commande : 
```sh
flutter run -d chrome lib/main_website.dart
```

- Pour visiter le site web en production, ouvrez votre navigateur et allez à l'adresse
```
https://front.colibris.live/#/login
```

## Membres du groupe

👤 **Dahbi Ossama**
* Github: [@Ossama9](https://github.com/Ossama9)

👤 **DEVECI Serkan**
* Github: [@sDev67](https://github.com/sDev67)

👤 **Jallu Thomas**
* Github: [@ThomasDev6](https://github.com/ThomasDev6)

👤 **Hamidou Kanoute**
* Github: [@hkanoute](https://github.com/hkanoute)


## Listes des features

| Personnes                                              | Fonctionnalité                                                                                                      |
|--------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| Deveci Serkan, Dahbi Ossama, Kanoute Hamidou                            | S'inscrire et se connecter                    |
| Dahbi Ossama, Jallu Thomas                              |  Espace votes                                                             |
| Deveci Serkan, Kanoute Hamidou                          |  Implémentation de la feature flipping dans le mobile et backoffice                                                             |
| Tous                                                    |  Ajout des droits par actions dans le mobile et backoffice                                                         |
| Jallu Thomas, Kanoute Hamidou                                            |  Proposer des services (tâches) avec prise de photo en mobile                                                               |
| Deveci Serkan, Kanoute Hamidou                          | Espace User (backoffice web)                                                                |
| Deveci Serkan                                           |  Espace Logs (backofficeweb)                                                                |
| Deveci Serkan                                           |  Internationnalisation de l'application                                                                |
| Dahbi Ossama, Jallu Thomas, Kanoute Hamidou                              | Chat en temps réel au sein de chaque colocations                 |
| Kanoute Hamidou, Dahbi Ossama                           | Setup de la ci&cd                 |
| Deveci Serkan, Dahbi Ossama                             | Page profile - Voir ses informations et les modifier                 |
| Deveci Serkan, Dahbi Ossama                             | Mot de passe oublié et envoi de mail pour réinitialiser                                                             |
| Deveci Serkan, Kanoute Hamidou, Jallu Thomas                          | Espace Colocation (Mobile et backoffice web)                                                                |
| Deveci Serkan, Kanoute Hamidou                          | Espace Membre par colocation backoffice web                                                           |
| Kanoute Hamidou, Deveci Serkan                          | Gérer les invitations pour la colocation                                                                    |
| Tous                                                    | Swagger                                                                                        |
| Kanoute Hamidou                                         | Tests d'intégrations                                                                                         |
| Dahbi Ossama                                         | Notification push sur téléphone à la réception d'un chat                                                              |


### Contraintes imposées dans le sujet
- **GoLang**
  - Système dʼauthentification (au minimum via login / mot de passe) ✅
  - Gestion multi-rôles (utilisateur simple, administrateur...) ✅
  - vérification des droits et filtrage des résultats lors des requêtes en fonction du rôle de lʼutilisateur connecté ✅
  - Interface Swagger UI pour interagir avec lʼAPI ✅
  - API CRUD sur les éléments fonctionnels de lʼapplication ✅
  - Configuration modifiable (via fichier de conf, variables dʼenvironnement, base de données...) ✅ 
  - API Web Socket fournissant au moins une fonctionnalité temps-réel ✅
  - Base de données relationnelle avec jeu de données conséquent représentatif des cas dʼusages de lʼapplication ❌
  - Logs formatés consultables ✅
  - Feature flipping : possibilité dʼactiver ou désactiver certaines fonctionnalités de sans redémarrer lʼapplication ✅
  - Utilisation de Go 1.22.1 ✅
  - API stateless, avec pagination des résultats ✅
  - Base de données Postgresql ✅
  - Erreurs : 
    - pas de “panicˮ dans le code, les erreurs doivent être correctement gérées ✅
    - renvoyer des erreurs fonctionnelles par lʼAPI et afficher le details des erreurs techniques dans les logs ✅
  - Sécurité : 
    - API hébergée en HTTPS avec certificat SSL et Respect des normes de développement standard OWASP... ✅
  - CleanCode : 
    - Le code doit être découpé en fichiers et dossiers cohérents et respecter les règles du clean code et SOLID (découpage, noms des variables et fonctions...) ✅
    - Code formaté et indenté avec Gofmt ✅
  - Tests : 
    - tests unitaires sur les règles de gestions de lʼapplications ❌
    - tests dʼintégration sur les endpoints de lʼAPI  ✅
    - tester aussi les cas dʼerreurs ✅


- **Flutter** 
  - Écrans différents en fonction des rôles de lʼutilisateur ✅
  - Utilisation dʼune technologie pseudo temps réel ✅
  - Envoi de notifications push ✅
  - Intégration du multilingue ✅
  - Panel dʼadministration cohérent pour contrôler les différentes entités du projet ✅
  - Affichage des événements survenant au sein de lʼapplication pour consultation ✅
  - Utilisation de plusieurs émulateurs ou terminaux pendant la soutenance pour faire les démonstrations nécessaires en fonction des différents profils ✅
  - Lʼapplication devra être visuellement responsive en fonction de la taille du téléphone / navigateur ✅
  - Le code rendu doit être propre et indenté correctement via les outils de base mis à disposition ✅

- **Fonctionnalité bonus** 
  - Servir les fichiers du front-end avec le binaire Golang (go embed) ⏳
  - Système d’authentification OAuth ⏳
  - Interface de consultation des logs (dans l’application ou via outil tierce KIBANA, Grafana…) avec graphiques et stats pertinentes (fréquentations, erreurs…) ⏳
  - Intégration de fonctionnalités tierces comme un carte Google Maps avec de la géolocalisation ✅
  - Scalabilité horizontale 
    - possibilité de déployer plusieurs instances de l’API derrière un load-balancer afin de supporter une fréquentation forte ⏳
  - tests de montée en charge ⏳

## DEMO
(décrire scénario utilisateur -- A venir)