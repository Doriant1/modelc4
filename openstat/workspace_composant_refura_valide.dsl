workspace "OpenStat - Vues Contexte et Conteneur" "Application de reporting pour les réseaux, services voix et vidéo, et services clients." {

    model {
        // === Acteurs Externes ===
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne ARG pour les services clients."
        atos = person "ATOS" "Développe et maintient l'application OpenStat."

        // === Portails d'Accès ===
        pex = softwareSystem "PEX" "Portail d’Exploitation pour la France."
        ece = softwareSystem "ECE" "Portail Internet pour la Relation Clients Entreprises (DEF et DGC)."
        mss = softwareSystem "MSS" "My Service Space pour l’international."
        arg = softwareSystem "ARG" "Interface interne pour les RSC et CSM."

        // === Système Central ===
        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations." {

            // === Conteneurs Internes ===
            refreport = container "RefReport / RefObject" "Référentiel des KPIs et des étapes de calculs." "Java"
            dataview = container "OpenDataView" "Interface Web pour la visualisation des rapports." "Python/Angular"
            refura = container "RefURA" "Gestion des authentifications et autorisations." "Java Spring Boot" {

                // === Composants Internes de RefURA ===
                component "Authentication Service" "Gère l'authentification des utilisateurs." "Spring Security"
                component "Authorization Service" "Gère les autorisations et permissions des utilisateurs." "Spring Boot"
                component "User Management Service" "Gère les informations des utilisateurs (création, mise à jour, suppression)." "Spring Boot"
            }

            openreport = container "OpenReport" "Calcul des KPI et analyses." "Java"
            cassandra = container "Cassandra" "Stockage des données collectées." "NoSQL Database"
            nas = container "NAS" "Stockage temporaire des fichiers et données collectées." "Stockage NFS"
            proxycollector = container "ProxyCollector" "Collecte des données des capteurs Orchestre (PCSNMP, Flexible Sensor, équipements divers)." "Java"
            opencollector = container "OpenCollector" "Rassemble et transfère les données collectées." "Java"
            openscheduler = container "OpenScheduler" "Ordonne et planifie les tâches et flux." "Java Quartz Scheduler"
            mom = container "MOM" "Bus d’ordre SOA pour la communication entre modules." "ActiveMQ/Kafka"
        }
// === Systèmes Fournisseurs de Données ===
        emf_inventory = softwareSystem "EMF Inventory" "Gère tout l'inventaire nécessaire au projet EMF (monitoring, reporting,...)"
        zen = softwareSystem "ZEN" "Infocentre des gisements des données pour les produits Numéris et Entreprises."
        wade = softwareSystem "WADE" "Portail des rapports de performance réseau des backbones IGN, RAEI et CGN."
        wasac = softwareSystem "WASAC" "Outil SCA pour automatiser la configuration des routeurs et switches CPE."
        big_data = softwareSystem "Big Data B2B MOS SBC" "Analyse les performances vocales via les CDR."
        gini = softwareSystem "GINI" "Centralise les inventaires techniques."

        // === Systèmes de Support et Supervision ===
        nmsa = softwareSystem "NMSA" "Support matériel et système pour OpenStat."
        asgen = softwareSystem "ASGEN" "Supervise les composants critiques."
        witbe = softwareSystem "Witbe" "Supervise les services via sondes."

        // === Applications Consommatrices ===
        groupbox = softwareSystem "GroupBox" "Détecte les alarmes groupées via OpenStat."
        wiperrest = softwareSystem "WIPERREST" "Service REST pour l'inventaire réseau."
        api_business_layer = softwareSystem "API Business Layer" "Publie des APIs sécurisées basées sur OpenStat."
        reporting_analytics = softwareSystem "Reporting Analytics" "Calcule et stocke les KPIs."
        monitoring_on_demand = softwareSystem "Monitoring On Demand" "Effectue du monitoring en temps réel."

        // === Interactions avec les Acteurs et Portails ===
        user_fr -> pex "Consulte les rapports réseau [Portail]."
        user_fr -> ece "Consulte les rapports client [Portail]."
        user_int -> mss "Consulte les rapports internationaux [Portail]."
        rsc_csm -> arg "Accède aux rapports via [Portail]."

        openstat -> pex "Fournit les rapports réseau [Portail]."
        openstat -> ece "Fournit les rapports entreprise [Portail]."
        openstat -> mss "Fournit les rapports internationaux [Portail]."
        openstat -> arg "Gère les services client [Portail]."

        // === Interactions avec les Fournisseurs de Données ===
        emf_inventory -> refreport "Fournit les données d'inventaire (SALTO, GINI) [Fournisseur]."
        zen -> proxycollector "Fournit les données GCN, VIVA et CLIP [Fournisseur]."
        wade -> openstat "Fournit les données IGN, RAEI et CGN [Fournisseur]."
        wasac -> openstat "Fournit les configurations réseau [Fournisseur]."
        big_data -> openstat "Fournit les CDR SBC pour les rapports qualité vocale [Fournisseur]."

        // === Interactions avec les Systèmes de Support et Supervision ===
        atos -> openstat "Développe et maintient OpenStat [Support]."
        nmsa -> openstat "Fournit le support matériel [Support]."
        asgen -> openstat "Supervise les composants critiques [Supervision]."
        witbe -> openstat "Supervise les services [Supervision]."

        // === Interactions avec les Consommateurs ===
        openstat -> groupbox "Fournit les données pour la détection d'alarmes [Consommateur]."
        openstat -> wiperrest "Fournit les données pour l'inventaire client [Consommateur]."
        openstat -> api_business_layer "Fournit les données pour les APIs sécurisées [Consommateur]."
        openstat -> reporting_analytics "Fournit les données pour les KPIs [Consommateur]."
        openstat -> monitoring_on_demand "Fournit les données pour le monitoring en temps réel [Consommateur]."

        // === Interactions entre Conteneurs Internes ===
        dataview -> refura "Demande d'authentification"
        refura -> dataview "Réponse d'authentification"
        dataview -> openreport "Demande d’accès aux rapports"
        openreport -> cassandra "Lit et écrit les données"
        openreport -> nas "Stockage temporaire des données"
        openreport -> refreport "Consulte les KPIs et règles de calcul"
        openreport -> mom "Orchestre les calculs"
        refreport -> nas "Stocke les données d'inventaire"
        openreport -> nas "Stocke temporairement les données"

        proxycollector -> opencollector "Transfert des données collectées"
        opencollector -> nas "Stocke les données brutes"
        opencollector -> mom "Envoie les messages de collecte"

        openscheduler -> mom "Orchestre les tâches et flux"
        openscheduler -> refreport "Demande les informations d'ordonnancement et reference"

        refreport -> openreport "Fournit les KPI et règles de calcul"
        refreport -> mom "Met à jour les référentiels et Synchronise les données"

        mom -> openreport "Envoie les tâches de calcul"
        mom -> refreport "Met à jour les référentiels"
        mom -> openscheduler "Planifie les tâches"
        mom -> opencollector "Orchestre la collecte des données"

    }

    // === Définition des Vues ===
    views {
        // Vue Contexte
        systemContext openstat {
            include *
            autoLayout lr
            title "Vue du Contexte Système pour OpenStat"
            description "Cette vue illustre les acteurs externes, les systèmes interagissant avec OpenStat et leurs interactions, y compris les systèmes de support et supervision."
        }

        // Vue Conteneur
        container openstat {
            include *
            autoLayout tb
            title "Vue Conteneur - OpenStat"
            description "Cette vue détaille les conteneurs internes d'OpenStat et leurs interactions avec les systèmes externes."
        }

        // Vue Composant pour RefURA
        component refura {
            include *
            autoLayout tb
            title "Vue Composant - RefURA"
            description "Cette vue détaille les composants internes de RefURA et leurs interactions."
        }

        // === Styles ===
        styles {
            element "Person" {
                background #2D882D
                color #ffffff
                shape person
            }
            element "Software System" {
                background #1168bd
                color #ffffff
                shape roundedBox
            }
            element "Container" {
                background #85bbf0
                color #ffffff
                shape hexagon
            }
            element "Component" {
                background #facc2e
                color #000000
                shape roundedBox
            }
        }
    }
}
