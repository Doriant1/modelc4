workspace "OpenStat - Vues Contexte et Conteneur" "Application de reporting pour les réseaux, services voix et vidéo, et services clients." {

    model {
        // === Acteurs Externes (inchangés) ===
        user_fr = person "Administrateur Réseau/Télécom (France)" "Accède aux rapports via les portails PEX et ECE."
        user_int = person "Administrateur Réseau/Télécom (International)" "Accède aux rapports via le portail MSS."
        rsc_csm = person "RSC et CSM" "Utilisent l'interface interne ARG/OAT pour les services clients."
        atos = person "ATOS" "Développe et maintient"
        nmsa = person "NMSA" "Support matériel et système (OINIS)"
        

        // === Portails d'Accès (inchangés) ===
        pex_ece = softwareSystem "PEX / ECE" "Portail Exploitation / Client pour la France."
        #ece = softwareSystem "ECE" "Portail Internet pour la Relation Clients Entreprises (DEF et DGC)."
        mss = softwareSystem "MSS" "My Service Space pour l’international."
        arg_oat = softwareSystem "ARG / OAT" "Interface interne pour les RSC et CSM."
        proxy_nas = softwareSystem "PROXY NAS" "Server NAS FTP pour users interne"
        openservices = softwareSystem "OpenServices" "Server stockage SFTP pour users externe/interne"
        

        // === Système Central OpenStat ===
        openstat = softwareSystem "OpenStat" "Application de reporting pour les réseaux, services de voix et de vidéo, et services clients et opérations." {

            // ----- Conteneurs Internes -----
            openscheduler = container "OpenScheduler (SCR)" "Ordonne et déclenche les tâches (jobs) de collecte et d’enrichissement via JMS (OpenMQ)." "Java (Quartz Scheduler)"
            
            proxycollector = container "ProxyCollector (PCX)" "Satellite autonome  qui téléconfigure les sources et collecte les fichiers via HTTP (Apache)." "Perl"

            opendataview = container "OpenDataView (ODS)" "Module dédié à la gestion des référentiels et de l’inventaire, collaborant avec RefObject et RefReport." "Java"

            refobject = container "RefObject (ROT)" "Référentiel des entités et objets d’inventaire. Il s’appuie sur deux bases : - JanusGraph Database (via Janus Provisioning) pour la consultation en temps réel, - OrientDB + Elasticsearch (via OrientDB Provisioning) pour l’export des fichiers." "Java" {
                
            // Composants internes de RefObject
                janusGraph = component "JanusGraph Database" "Base de données alimentée par Janus Provisioning pour la consultation en temps réel des entités d’inventaire." "JanusGraph"
                orientDBES = component "OrientDB + Elasticsearch Database" "Base utilisée pour le provisioning via OrientDB Provisioning et l’export des fichiers." "OrientDB/Elasticsearch"
                consultationServices = component "Consultation Services" "Exporte des services REST pour l’interrogation en temps réel des données d’inventaire." "REST API"
                exportToFiles = component "Export to Files" "Génère les fichiers exportés (OrientDB Exported Files) destinés à être importés par RefReport." "Fichiers plats"

            // Interactions entre composants RefObject 
                janusGraph -> consultationServices "Fournit les données pour consultation."
                orientDBES -> exportToFiles "Génère les fichiers exportés."
                //exportToFiles -> refreport "Envoie les OrientDB Exported Files pour importation."
            }
            refreport = container "RefReport (RRT)" "Référentiel de la configuration des rapports et des sources à collecter." "Java" {
            // Composants internes de RefReport
                importToRefReport = component "Import to RefReport" "Importe les fichiers exportés depuis RefObject pour alimenter l’inventaire." "REST API"
                sqlReportConfig = component "SQL Database for Report Configuration" "Base SQL H2 contenant la configuration des rapports." "SQL (H2)"
                sqlInventory = component "SQL Database for Inventory" "Base SQL H2 contenant l'inventaire des sources à collecter." "SQL (H2)"
                exportH2Reports = component "Export H2 Reports" "Exporte la configuration des rapports sous forme de Report H2 Export." "Fichiers plats"
                exportH2Inventory = component "Export H2 Inventory" "Exporte l'inventaire sous forme d'Inventory H2 Export." "Fichiers plats"
                reportsProvisioning = component "Reports Provisioning" "Alimente la configuration des rapports à partir des Provisioning Files et Configuration Files." "Fichiers de configuration"

            // Interactions internes
                importToRefReport -> sqlInventory "Alimente la base d'inventaire."
                reportsProvisioning -> sqlReportConfig "Alimente la configuration des rapports."
                sqlReportConfig -> exportH2Reports "Génère le Report H2 Export."
                sqlInventory -> exportH2Inventory "Génère l'Inventory H2 Export."
    
            }

            refura = container "RefURA (RUA)" "Référentiel des droits, des utilisateurs et des campagnes OpenFlow, ainsi que la configuration des serveurs OpenStat." "Java Spring Boot"

            opencollector = container "OpenCollector (OCR)" "Module Java qui récupère les données collectées par ProxyCollector, les découpe, les stocke temporairement sur le NAS et met à jour l’état de collecte dans RefReport." "Java"

            openreport = container "OpenReport (OPR)" "Application Java qui transforme les données (via rapports Extended), stocke les données enrichies dans Cassandra et génère les rapports destinés aux utilisateurs." "Java" {
                // Composants internes de OpenReport
                kpiCalculation = component "KPI Calculation Service" "Effectue les calculs des indicateurs clés à partir des données collectées." "Java"
                dataMediation = component "Data Mediation Service" "Transforme et prépare les données collectées pour analyses." "Java"
                analyticsEngine = component "Analytics Engine" "Réalise des analyses avancées sur les données." "Java"
                transformationService = component "Report Transformation Service" "Transforme les données brutes en données enrichies via un rapport Extended." "Java"

                // Interactions internes
                kpiCalculation -> dataMediation "Utilise les données transformées pour les calculs."
                dataMediation -> analyticsEngine "Fournit les données pour analyses approfondies."
                dataMediation -> transformationService "Transmet les données pour transformation."
               // transformationService -> cassandra "Stocke les données enrichies dans Cassandra."
            }

            cassandra = container "Cassandra" "Base NoSQL utilisée pour stocker les données brutes ou enrichies après transformation." "NoSQL Database"
            nas = container "NAS" "Stockage temporaire des fichiers et données collectées." "Stockage NFS"
            mom = container "MOM" "Bus de messagerie assurant les communications JMS (Java Message Service) entre OpenScheduler, OpenCollector et les référentiels." "OpenMQ"


        }

        // === Systèmes Fournisseurs de Données ===
        emf_inventory = softwareSystem "EMF Inventory" "Gère tout l'inventaire nécessaire au projet EMF (monitoring, reporting,...)."
        #zen = softwareSystem "ZEN" "Infocentre des gisements des données pour les produits Numéris et Entreprises."
        wade = softwareSystem "WADE" "Portail des rapports de performance réseau des backbones IGN, RAEI et CGN."
        #wasac = softwareSystem "WASAC" "Outil SCA pour automatiser la configuration des routeurs et switches CPE."
        big_data = softwareSystem "Big Data B2B MOS SBC (Hookah)" "Analyse les performances vocales via les CDR."
        gini = softwareSystem "GINI" "Centralise les inventaires techniques."
        orchestre = softwareSystem "Orchestre" "Outils d'administration de réseaux"
        #Hookah = softwareSystem "Hookah" "Plateforme voix"

        // === Systèmes de Support et Supervision ===
        asgen = softwareSystem "ASGEN" "Supervise les devices critiques."
        witbe = softwareSystem "Witbe" "Supervise les services via sondes."

        // === Applications Consommatrices ===
        #groupbox = softwareSystem "GroupBox" "Détecte les alarmes groupées via OpenStat."
        #wiperrest = softwareSystem "WIPERREST" "Service REST pour l'inventaire réseau."
        api_business_layer = softwareSystem "API Business Layer" "Publie des APIs sécurisées basées sur OpenStat (en DEV)."
        reporting_analytics = softwareSystem "Reporting Analytics (ORA)" "Calcule et stocke les KPIs."
        monitoring_on_demand = softwareSystem "Monitoring On Demand" "Effectue du monitoring en temps réel."

        // ----- Interactions entre Conteneurs Internes -----
            // === Interactions avec les Acteurs et Portails ===
        #user_fr -> pex "Consulte les rapports réseau [Portail]."
        #user_fr -> ece "Consulte les rapports client [Portail]."
        user_int -> mss "Consulte les rapports internationaux [Portail]."
        rsc_csm -> arg_oat "Accède aux rapports via [Portail]."
        openstat -> pex_ece "Fournit les rapports clients (Fr) [Portail]."
        #openstat -> pex_ece "Fournit les rapports client (Fr) [Portail]."
        openstat -> mss "Fournit les rapports internationaux via web ou API (Wiperrest) [Portail]."
        openstat -> arg_oat "Gère les services client [Portail]."
        openstat -> proxy_nas "Fournit les rapports via FTP"
        openstat -> openservices "Fournit les rapports via SFTP"
        orchestre -> openstat "Fournit les données réseaux"

        // === Interactions avec les Fournisseurs de Données ===
        Orchestre -> refobject "Fournit les données réseaux  [Fournisseur]."
        Orchestre -> proxycollector "Fournit les données réseaux  [Fournisseur]."
        big_data -> proxycollector "Fournit les données voix (Hookah)"
        #zen -> proxycollector "Fournit les données GCN, VIVA et CLIP [Fournisseur]."
        wade -> openstat "Fournit les données IGN, RAEI et CGN [Fournisseur]."
        #wasac -> openstat "Fournit les configurations réseau [Fournisseur]."
        big_data -> openstat "Fournit les CDR SBC pour les rapports qualité vocale [Fournisseur]."
        gini -> openstat "Fournit les données d'inventaires"
        // === Interactions avec les Systèmes de Support et Supervision ===
        atos -> openstat "Développe et maintient OpenStat [Support]."
        nmsa -> openstat "Fournit le support matériel [Support]."
        asgen -> openstat "Supervise les devices  [Supervision]."
        witbe -> openstat "Supervise les services [Supervision]."

        // === Interactions avec les Consommateurs ===
        #openstat -> groupbox "Fournit les données pour la détection d'alarmes [Consommateur]."
        #openstat -> wiperrest "Fournit les données pour l'inventaire client [Consommateur]."
        openstat -> api_business_layer "Fournit les données pour les APIs sécurisées [Consommateur]."
        openstat -> reporting_analytics "Fournit les données pour les KPIs [Consommateur]."
        openstat -> monitoring_on_demand "Fournit les données périmètre clients [Consommateur]."

        // === Interactions entre Conteneurs Internes ===
        opendataview -> refura "Demande d'authentification"
        refura -> opendataview "Réponse d'authentification"
        opendataview -> openreport "Demande d’accès aux rapports"
        opendataview -> refobject "Synchronise les données d’inventaire."
        gini -> refobject "fournit les données d'inventaires"
        opendataview -> refreport "Synchronise la configuration des rapports et l’inventaire."
        openreport -> cassandra "Stocke les données enrichies après transformation (rapport Extended)."
        openscheduler -> cassandra "Stocke les tables des jobs à éxécuter"
        openreport -> nas "Stockage temporaire des données"
        openreport -> refreport "Consulte les KPIs et règles de calcul"
        proxycollector -> opencollector "Expose les fichiers collectés via HTTP (serveur Apache)."
        opencollector -> nas "Stocke les données brutes en les découpant"
        openreport -> mom "Orchestre les calculs"
        refreport -> nas "Stocke les données d'inventaire"
        refreport -> proxycollector "Configure pour collecter la source avec les paramètres prédéfinis."
        openreport -> nas "Stocke temporairement les données"
        opencollector -> mom "Envoie les messages de collecte"
        opencollector -> proxycollector "Récupére la liste et le contenu des fichiers de la source via REST."
        atos -> proxycollector "code un nouveau connecteur"
        opencollector -> refreport "Consulte et met à jour l’état de collecte via REST (table T_INPUT_SOURCE)."
        opencollector -> openreport "Transmet les données collectées pour transformation."

        openscheduler -> mom "Envoie des jobs (COLLECT_SOURCE, SPLIT_SOURCE) via JMS."
        openscheduler -> refreport "Demande les informations d'ordonnancement et reference"

        refreport -> openreport "Fournit les KPI et règles de calcul"
        refreport -> mom "Met à jour les référentiels et Synchronise les données"

        mom -> openreport "Envoie les tâches de calcul"
        mom -> refreport "Synchronise les référentiels et met à jour la configuration."
        mom -> openscheduler "Orchestre et planifie les tâches de collecte."
        mom -> opencollector "Orchestre la collecte des données"

        refobject -> refreport "Exporte les OrientDB Exported Files pour importation via le composant Import to RefReport."
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

        // Vue Composant pour RefObject
        component refobject {
            include *
            autoLayout tb
            title "Vue Composant - RefObject"
            description "Cette vue détaille les composants internes de RefObject et leurs interactions."
        }

        // Vue Composant pour RefURA
        component refura {
            include *
            autoLayout tb
            title "Vue Composant - RefURA"
            description "Cette vue détaille les composants internes de RefURA et leurs interactions."
        }

        // Vue Composant pour OpenReport
        component openreport {
            include *
            autoLayout tb
            title "Vue Composant - OpenReport"
            description "Cette vue détaille les composants internes de OpenReport et leurs interactions."
        }
    
    // ----- Styles (inchangés) -----
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
        element "Deployment Node" {
            background #d9534f
            color #ffffff
            shape cylinder
        }
        element "Container Instance" {
            background #f0ad4e
            color #000000
            shape roundedBox
        }
       // element "Deployment Node" {
        //    background #d9534f
        //    color #ffffff
         //   shape cylinder
       // }
       // element "Container Instance" {
       //     background #f0ad4e
       //     color #000000
       //     shape roundedBox
       // }
        }
    }
}    


