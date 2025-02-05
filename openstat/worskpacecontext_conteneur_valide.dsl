workspace "OpenStat" "Application de reporting pour les réseaux, services voix et vidéo, et services clients" {

    model {
        // Acteurs Externes
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne ARG pour les services clients."

        // Portails d'accès
        pex = softwareSystem "PEX" "Portail d’Exploitation pour la France."
        ece = softwareSystem "ECE" "Espace Client Entreprise pour la France."
        mss = softwareSystem "MSS" "My Service Space pour l’international."
        arg = softwareSystem "ARG" "Interface interne pour les RSC et CSM."

        // Système Central
        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations." {

            // Définition des Conteneurs Internes
            dashboard = container "OpenDashBoard" "Interface Web pour la visualisation des rapports." "Angular/React"
            refura = container "RefURA" "Gestion des authentifications et autorisations." "Java Spring Boot"
            openreport = container "OpenReport" "Calcul des KPI et analyses." "Python/Scala"
            cassandra = container "Cassandra" "Stockage des données collectées." "NoSQL Database"
            nas = container "NAS" "Stockage temporaire des fichiers et données collectées." "Stockage NFS"
            proxycollector = container "ProxyCollector" "Collecte des données des sources externes." "Python"
            opencollector = container "OpenCollector" "Rassemble et transfère les données collectées." "Java"
            openscheduler = container "OpenScheduler" "Ordonne et planifie les tâches et flux." "Java Quartz Scheduler"
            refreport = container "RefReport / RefObject" "Référentiel des KPIs et des étapes de calculs." "Java"
            mom = container "MOM" "Bus d’ordre SOA pour la communication entre modules." "ActiveMQ/Kafka"
        }

        // Autres Systèmes Externes
        atos = softwareSystem "ATOS" "Assure le développement de l'application et le support niveau 2/3."
        nmsa = softwareSystem "NMSA" "Fournit le support matériel et système."
        asgen = softwareSystem "ASGEN" "Supervision système et applicative pour les composants critiques d'OpenStat."
        witbe = softwareSystem "Witbe" "Supervision des services via des sondes."

        // Interactions avec les systèmes externes
        openstat -> pex "Fournit les rapports réseau"
        openstat -> ece "Fournit les rapports entreprise"
        openstat -> mss "Fournit les rapports internationaux"
        openstat -> arg "Gère les services client"

        atos -> openstat "Développe et maintient"
        nmsa -> openstat "Fournit le support pour"
        asgen -> openstat "Supervise"
        witbe -> openstat "Supervise les services de"

        // Interactions entre les Acteurs et les systèmes externes
        user_fr -> pex "Consulte les rapports via"
        user_fr -> ece "Consulte les rapports via"
        user_int -> mss "Consulte les rapports via"
        rsc_csm -> arg "Accède aux rapports et administre les services via"

        // Interactions entre Conteneurs
        dashboard -> refura "Demande d'authentification"
        refura -> dashboard "Réponse d'authentification"
        dashboard -> openreport "Demande d’accès aux rapports"
        openreport -> cassandra "Lit et écrit les données"
        openreport -> nas "Stockage temporaire"
        openreport -> refreport "Consulte les KPIs et règles de calcul"
        openreport -> mom "Orchestre les calculs"

        proxycollector -> opencollector "Transfert des données collectées"
        opencollector -> nas "Stocke les données brutes"
        opencollector -> mom "Envoie les messages de collecte"

        openscheduler -> mom "Orchestre les tâches"
        openscheduler -> refreport "Demande les informations d'ordonnancement"

        refreport -> openreport "Fournit les KPI et règles de calcul"
        refreport -> mom "Synchronise les données de référence"

        mom -> openreport "Envoie les tâches de calcul"
        mom -> refreport "Met à jour les référentiels"
        mom -> openscheduler "Planifie les tâches"
        mom -> opencollector "Orchestre la collecte des données"
    }

    views {
        // Vue Contexte
        systemContext openstat {
            include *
            autoLayout lr
            title "Vue Contexte - OpenStat"
            description "Vue globale des acteurs externes et des interactions avec OpenStat."
        }

        // Vue Conteneur
        container openstat {
            include *
            autoLayout tb
            title "Vue Conteneur - OpenStat"
            description "Détails des composants internes et interactions d'OpenStat, ainsi que des systèmes externes associés."
        }

        // Styles d'affichage
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
            }
        }
    }
}
