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
    <li><a href="#tests">Tests</a></li>
    <li><a href="#apk">APK</a></li>
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
  - Base de données relationnelle avec jeu de données conséquent représentatif des cas dʼusages de lʼapplication ✅
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
    - tests unitaires sur les règles de gestions de lʼapplications ✅
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
  - Servir les fichiers du front-end avec le binaire Golang (go embed) ❌
  - Système d’authentification OAuth ✅
  - Interface de consultation des logs (dans l’application ou via outil tierce KIBANA, **Grafana…**) avec graphiques et stats pertinentes (fréquentations, erreurs…) ✅
  - Intégration de fonctionnalités tierces comme un carte Google Maps avec de la géolocalisation ✅
  - Scalabilité horizontale ❌
    - possibilité de déployer plusieurs instances de l’API derrière un load-balancer afin de supporter une fréquentation forte ❌
  - tests de montée en charge ❌


## Tests 
- Les tests s'éxecutent lorsqu'il y a une PR sur la branche `main` et `dev`.
- Pour lancer les tests, il faut se rendre dans le dossier `Back` et s'assurer que le Docker tourne et executer les commandes suivantes : 
```sh
docker-compose exec -T golang go test tests/utils.go tests/register_test.go
docker-compose exec -T golang go test tests/utils.go tests/login_test.go
docker-compose exec -T golang go test tests/utils.go tests/colocation_test.go
docker-compose exec -T golang go test tests/utils.go tests/featureFlag_test.go
docker-compose exec -T golang go test tests/utils.go tests/colocMember_test.go
docker-compose exec -T golang go test tests/utils.go tests/invitation_test.go
docker-compose exec -T golang go test tests/jwt_unitary_test.go
```

## Links ( may be shuttdown)  
### APK : 
https://drive.google.com/file/d/1jzwjF56Yioc8KCLNk9aF28xiHbBV2V1z/view
### Swagger 
https://back.colibris.live/api/v1/swagger/index.html
### Front : 
https://front.colibris.live

## DEMO
### A préparer en amont pour la démo
- créer un utilisateur :
    - user 1 : 
        -  nom : demo
        - prénom : esgi
        - email : esgi.user@yopmail.com
        - role : user
        
    - user 2 :
        - nom : Bond
        - prénom : james
        - email : james9@yopmail.com
        - role : user

    - user 3 :
        - nom : Doe
        - prénom : John
        - email : john9@yopmail.com
        - role : user

- Créer 1 colocations :
    - par user demo (esgi.user@yopmail.com) :
        - nom : Chez l'esgi
        -  description : C'est la fête ici
        - ville : Paris
        - permantente : true
    
- Créer taches :
    - par user demo (esgi.user@yopmail.com) :
        - nom : Les courses
        -  description : J'ai fais les courses
    
- Connecter en Oauth pour hamidou pour avoir dans la bdd déjà son user :

- Au final dans colocation "Chez l'esgi" on a :
    - user demo (esgi.user@yopmail.com)
    - user bond james ( james9@yopmail.com)
    - john doe (john9@yopmail.com)


### Démo

**ANDROID STUDIO :** 

- Tester le forget password avec l'user demo esgi (esgi.user@yopmaim.com)

- Se connecter avec cet utilisateur

- il voit qu'il a une colocations

- il clique sur "Chez l'esgi" et il est owner de la colocation car il a accès aux paramètres

- il voit toutes les tâches faites dans la colocation et **clique** sur "mes taches" pour voir ce qu'il a faites lui meme

- il clique sur le détail de la tache "Les courses" et consulte les détails.

- il va dans le chat pour dire qu'il y a un nouveau colocataire qui arrive

- il va ensuite sur sur les paramètres de la colocations et invite 1 autre user

- ensuite il va voir les autres membres pour consulter les scores.

- il va ensuite dans la page profil pour dire qu'on peut changer de langue (action qui le déconnecte) 

- mettre l'appli bg

  
**Backoffice :** (admin@admin.com)

- admin se connecte

- il va dans la card user et cherche l'utilisateur "John Doe" et modifie pour lui mettre le nom "martin dupond"

- il va dans la card colocation et voit les messages de la colocation "Chez l'esgi"

- il met un message lui aussi de bonjour
  

**TELEPHONE:**

- se connecter avec oauth 

- accepter l'invitation

- creer tache presentation en live et prendre une photo noir

- dans le chat il demande a voter

- mettre l'appli en bg

  

**ANDROID STUDIO (esgi.user@yopmail.com):**

- il clique sur la notif et met un msg pour dire qu'il va voter

  
**TELEFONE: (OAuth)**

- cliquer sur la notif et dire ok merci et on attends les msg

  
**ANDROID STUDIO (esgi.user@yopmail.com):**

- va voter :thumbsdown:

- et dans le chat il dit que la photo on voit rien

**TELEPHONE:**

- va editer la tache et mettre une autre photo

- et dans le chat il dit que c'est fait

- deconnecter

  
**ANDROID STUDIO (esgi.user@yopmail.com) :**

- va regarder la tache et voit la bonne image

- va voter :thumbsup:

- ensuite il va voir les autres membres pour consulter les scores et voit que l'user a son score à jour.

- il voit qu'un mec n'a rien fait il le vire (martin dupond)

- et vient dans la home screen


**Backoffice** : (admin@admin.com)

- Activer la feature flipping

- dire dans le chat dans que c'est la maintenance


**ANDROID STUDIO (esgi.user@yopmail.com) :**

- montrer les notifs

**TELEPHONE:**

- montrer les notifs

**Backoffice :**

- desactiver la feature flipping

**Backoffice :**

- On montre les cards colocMember et on montre la feature de la carte

- on a des cruds sur les taches

- on termine avec les logs et parlez de graphana

  
**FIN**

- Grafana

- Présenter le Readme 

- Ec2

- Github actions

- Swagger
