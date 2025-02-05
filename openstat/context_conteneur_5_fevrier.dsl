workspace "OpenStat - Vues Contexte et Conteneur" "Application de reporting pour les réseaux, services voix et vidéo, et services clients." {

    model {
        // === Acteurs Externes ===
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne ARG pour les services clients."

        // === Portails d'accès ===
        pex = softwareSystem "PEX" "Portail d’Exploitation pour la France."
        ece = softwareSystem "ECE" "Portail Internet pour la Relation Clients Entreprises (DEF et DGC)."
        mss = softwareSystem "MSS" "My Service Space pour l’international."
        arg = softwareSystem "ARG" "Interface interne pour les RSC et CSM."

        // === Système Central : OpenStat ===
        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations." {

            // === Conteneurs Internes ===
            dashboard = container "OpenDashBoard" "Interface Web pour la visualisation des rapports." "Angular/React"
            refura = container "RefURA" "Gestion des authentifications et autorisations." "Java Spring Boot"
            openreport = container "OpenReport" "Calcul des KPI et analyses." "Python/Scala"
            cassandra = container "Cassandra" "Stockage des données collectées." "NoSQL Database"
            nas = container "NAS" "Stockage temporaire des fichiers et données collectées." "Stockage NFS"
            proxycollector = container "ProxyCollector" "Collecte des données des capteurs Orchestre (PCSNMP, Flexible Sensor, équipements divers)." "Python"
            opencollector = container "OpenCollector" "Rassemble et transfère les données collectées." "Java"
            openscheduler = container "OpenScheduler" "Ordonne et planifie les tâches et flux." "Java Quartz Scheduler"
            refreport = container "RefReport / RefObject" "Référentiel des KPIs et des étapes de calculs." "Java"
            mom = container "MOM" "Bus d’ordre SOA pour la communication entre modules." "ActiveMQ/Kafka"
        }

        // === Systèmes Externes Fournisseurs de Données ===
        emf_inventory = softwareSystem "EMF Inventory" "Gère tout l'inventaire nécessaire au projet EMF (monitoring, reporting,...)."
        zen = softwareSystem "ZEN" "Infocentre des gisements des données pour les produits Numéris et Entreprises."
        wade = softwareSystem "WADE" "Portail des rapports de performance réseau des backbones IGN, RAEI et CGN."
        wasac = softwareSystem "WASAC" "Outil SCA pour automatiser la configuration des routeurs et switches CPE."
        big_data = softwareSystem "Big Data B2B MOS SBC" "Outil Big Data pour une analyse enrichie des performances réseau."
        gini = softwareSystem "GINI" "Outil centralisé d'inventaire et d'affectation des ressources réseau."

        // === Systèmes Externes de Support et Supervision ===
        atos = softwareSystem "ATOS" "Développement de l'application et support niveau 2/3."
        nmsa = softwareSystem "NMSA" "Support matériel et système pour OpenStat."
        asgen = softwareSystem "ASGEN" "Supervision système et applicative des composants critiques d'OpenStat."
        witbe = softwareSystem "Witbe" "Supervision des services réseau via des sondes."

        // === Applications Consommatrices de Données OpenStat ===
        groupbox = softwareSystem "GroupBox" "Détection de groupements d'alarmes issues des données OpenStat."
        wiperrest = softwareSystem "WIPERREST" "Service REST pour l'inventaire et le reporting client."
        api_business_layer = softwareSystem "API Business Layer" "Middleware pour agréger et publier des APIs basées sur OpenStat."
        reporting_analytics = softwareSystem "Reporting Analytics (Ab Initio)" "Outil ETL pour calculer les KPIs et les stocker."
        monitoring_on_demand = softwareSystem "Monitoring On Demand" "Outil de monitoring en temps réel basé sur OpenStat."

        // === Interactions ===
        atos -> openstat "Développe et fournit le support technique."
        nmsa -> openstat "Assure le support matériel et système."
        asgen -> openstat "Supervise les composants critiques."
        witbe -> openstat "Supervise les services réseau via des sondes."

        emf_inventory -> proxycollector "Fournit les données d'inventaire (SALTO, GINI)."
        zen -> proxycollector "Fournit les données GCN, VIVA et CLIP."
        proxycollector -> opencollector "Collecte et transmet les données à OpenCollector."
        opencollector -> nas "Stocke temporairement les données brutes."
        opencollector -> mom "Transmet les données collectées pour traitement."

        wade -> openstat "Fournit les données IGN, RAEI et CGN."
        wasac -> openstat "Fournit des données de configuration des routeurs et switches."
        big_data -> openstat "Fournit les CDR SBC pour les rapports qualité vocale."

        openstat -> groupbox "Fournit les données pour la détection d'alarmes."
        openstat -> wiperrest "Fournit les données pour l'inventaire et le reporting client."
        openstat -> api_business_layer "Fournit les données pour l'agrégation et les APIs sécurisées."
        openstat -> reporting_analytics "Fournit les données pour les calculs de KPI et le stockage."
        openstat -> monitoring_on_demand "Fournit les données pour le monitoring en temps réel."

        openstat -> pex "Fournit les rapports réseau."
        openstat -> ece "Fournit les rapports entreprise."
        openstat -> mss "Fournit les rapports internationaux."
        openstat -> arg "Gère les services client."

        user_fr -> pex "Consulte les rapports via."
        user_fr -> ece "Consulte les rapports via."
        user_int -> mss "Consulte les rapports via."
        rsc_csm -> arg "Accède aux rapports via."
    }

    views {
        // === Vue Contexte ===
        systemContext openstat {
            include *
            autoLayout lr
            title "Vue du Contexte Système pour OpenStat"
            description "Cette vue montre les interactions entre OpenStat et les systèmes externes, y compris les acteurs, fournisseurs, consommateurs, et superviseurs."
        }

        // === Vue Conteneur ===
        container openstat {
            include *
            autoLayout tb
            title "Vue Conteneur - OpenStat"
            description "Cette vue détaille les conteneurs internes d'OpenStat et leurs interactions avec les systèmes externes."
        }

        // === Styles ===
        styles {
            element "Person" {
                background #08427b
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
            relationship {
                color #707070
                thickness 2
                dashed false
            }
        }
    }
}
