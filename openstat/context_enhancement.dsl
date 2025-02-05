workspace "OpenStat - Vues Contexte et Conteneur" "Application de reporting pour les réseaux, services voix et vidéo, et services clients." {
    model {
        // === Acteurs Externes ===
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne  pour les services clients."
        atos = person "ATOS" "Fournit le support technique et le développement de l'application OpenStat."

        // === Portails ===
        pex = softwareSystem "PEX" "Portail d’Exploitation pour la France."
        ece = softwareSystem "ECE" "Portail Internet pour la Relation Clients Entreprises (DEF et DGC)."
        mss = softwareSystem "MSS" "My Service Space pour l’international."
        oat = softwareSystem "OAT" "OpenStat Admin Tool, outil interne pour les RSC et CSM."
        // === Système Central : OpenStat ===
        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations."

        // === Systèmes Fournisseurs de Données ===
        emf_inventory = softwareSystem "EMF Inventory" "Fournit l'inventaire pour le projet EMF."
        zen = softwareSystem "ZEN" "Fournit les données GCN, VIVA et CLIP."
        wade = softwareSystem "WADE" "Fournit les données IGN, RAEI et CGN."
        wasac = softwareSystem "WASAC" "Fournit les configurations des routeurs et switches."
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

        // === Interactions ===
        atos -> openstat "Développe et maintient OpenStat."
        emf_inventory -> openstat "Fournit des données d'inventaire."
        zen -> openstat "Fournit les données GCN, VIVA et CLIP."
        wade -> openstat "Fournit les données IGN, RAEI et CGN."
        wasac -> openstat "Fournit les configurations réseau."
        big_data -> openstat "Fournit les CDR SBC."
        
        nmsa -> openstat "Fournit le support matériel."
        asgen -> openstat "Supervise le système."
        witbe -> openstat "Supervise les services."

        openstat -> groupbox "Fournit les données pour la détection d'alarmes."
        openstat -> wiperrest "Fournit les données pour le reporting client."
        openstat -> api_business_layer "Fournit les données pour les APIs."
        openstat -> reporting_analytics "Fournit les données pour les KPIs."
        openstat -> monitoring_on_demand "Fournit les données pour le monitoring."
        openstat -> oat "Fournit les rapports services clients"
        openstat -> pex "Fournit les rapports réseau."
        openstat -> ece "Fournit les rapports entreprise."
        openstat -> mss "Fournit les rapports internationaux."

        user_fr -> pex "Consulte les rapports réseau."
        user_fr -> ece "Consulte les rapports client."
        user_int -> mss "Consulte les rapports internationaux."
        rsc_csm -> oat "Accède aux services clients et aux rapports."
    }

    views {
        // === Vue Contexte ===
        systemContext openstat {
            include *
            autoLayout lr
            title "Vue Contexte - OpenStat"
            description "Cette vue montre les interactions entre OpenStat, les acteurs externes, les portails, et les systèmes externes, y compris OAT."
        }

        // === Vue Conteneur ===
        container openstat {
            include *
            autoLayout tb
            title "Vue Conteneur - OpenStat"
            description "Cette vue détaille les conteneurs internes d'OpenStat et leurs interactions avec les systèmes externes, y compris OAT."
        }

        // === Styles ===
        styles {
            element "Person" {
                background #08427b
                color #ffffff
                shape person
            }
            element "Software System" {
                background #2D882D
                color #ffffff
                shape roundedBox
            }
            element "Container" {
                background #85bbf0
                color #ffffff
                shape hexagon
            }
        }
    }
}
