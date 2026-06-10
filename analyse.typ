// ============================================================
//  TEMPLATE MAISON — Rapport d'analyse  (style académique)
//  Auteur : van der Veen Georgé — Ifosup Wavre
// ============================================================

#let projet(
  title: "",
  subtitle: none,
  doctype: "Projet UML",
  author: "",
  school: "",
  branch: "",
  academic-year: "",
  mentors: (),
  footer-text: "",
  accent: rgb("#6e1423"), // bordeaux sobre — modifiable
  body,
) = {
  set document(title: title, author: author)
  set text(font: "Latin Modern Roman", size: 11pt, lang: "fr")
  set par(justify: true, leading: 0.72em, first-line-indent: (amount: 1.2em, all: true))

  let spaced(it) = smallcaps(text(tracking: 1.6pt)[#it])

  // -------- PAGE DE GARDE --------
  page(
    margin: (top: 3.2cm, bottom: 3.2cm, x: 3cm),
    header: none,
    footer: none,
  )[
    #set align(center)
    #set par(first-line-indent: 0pt, justify: false)

    #spaced(text(size: 12pt)[#school])
    #if branch != "" [
      #v(0.35em)
      #text(size: 10.5pt, style: "italic", fill: luma(90))[#branch]
    ]

    #v(1fr)

    // Bloc titre encadré de filets fins
    #line(length: 100%, stroke: 0.6pt + accent)
    #v(0.9cm)
    #text(size: 15pt, fill: accent)[#spaced(doctype)]
    #v(0.7cm)
    #text(size: 30pt, weight: "regular")[#title]
    #if subtitle != none [
      #v(0.5cm)
      #text(size: 15pt, style: "italic", fill: luma(70))[#subtitle]
    ]
    #v(0.9cm)
    #line(length: 100%, stroke: 0.6pt + accent)

    #v(1fr)

    #spaced(text(size: 13pt)[#author])
    #if mentors.len() > 0 [
      #v(1cm)
      #text(size: 10pt, fill: luma(80))[
        #emph[Sous la supervision de] #linebreak()
        #mentors.join(linebreak())
      ]
    ]

    #v(1.2cm)
    #text(size: 11pt, fill: luma(60))[Année académique #academic-year]
  ]

  // -------- CORPS DU DOCUMENT --------
  set page(
    margin: (top: 2.6cm, bottom: 2.6cm, x: 3cm),
    header: context {
      if counter(page).get().first() > 1 {
        set text(size: 9pt, style: "italic", fill: luma(110))
        grid(
          columns: (1fr, auto),
          align: (left, right),
          [#title], [#spaced(text(size: 8pt)[#school])],
        )
        v(-0.4em)
        line(length: 100%, stroke: 0.4pt + luma(160))
      }
    },
    footer: context {
      set text(size: 9pt, fill: luma(110))
      line(length: 100%, stroke: 0.4pt + luma(160))
      v(0.2em)
      grid(
        columns: (1fr, auto),
        align: (left, right),
        text(style: "italic")[#footer-text], counter(page).display("1 / 1", both: true),
      )
    },
  )
  counter(page).update(1)

  set heading(numbering: "1.1")
  show heading.where(level: 1): it => {
    set text(size: 15pt, weight: "regular", fill: accent)
    block(above: 1.5em, below: 1em)[
      #spaced[#counter(heading).display() #h(0.6em) #it.body]
    ]
  }
  show heading.where(level: 2): it => {
    set text(size: 12pt, weight: "bold", fill: luma(40))
    block(above: 1.2em, below: 0.8em)[
      #counter(heading).display() #h(0.5em) #it.body
    ]
  }

  set table(
    stroke: (x, y) => (
      top: if y == 0 { 0.7pt + accent } else { 0.3pt + luma(180) },
      bottom: 0.3pt + luma(180),
    ),
    fill: (x, y) => if y == 0 { accent.lighten(90%) },
  )

  // -------- TABLE DES MATIÈRES --------
  {
    set par(first-line-indent: 0pt)
    show outline.entry.where(level: 1): it => {
      v(0.5em)
      strong(it)
    }
    outline(title: [Table des matières], indent: auto, depth: 2)
  }
  pagebreak()

  body
}

// ============================================================
//  CONFIGURATION DU DOCUMENT
// ============================================================

#show: projet.with(
  title: [Jeu de quiz~« Projet Cultissime~»],
  subtitle: "Analyse et conception",
  doctype: "Projet UML",
  author: "van der Veen Georgé",
  school: "Ifosup Wavre",
  branch: "Conception et développement d'applications",
  academic-year: "2025-2026",
  footer-text: "van der Veen Georgé",
)

= Cahier des charges

== Contexte et origine de la demande

Ce projet émane d'un constat personnel : un manque dans l'offre actuelle de jeux de quiz. La demande n'a donc pas d'origine externe ; c'est l'auteur lui-même qui, à partir de sa propre expérience de joueur, est à l'origine de la démarche. Le projet prend pour référence principale le jeu en ligne PopSauce, dont le principe consiste à rejoindre un salon et à répondre le plus rapidement possible à des questions de culture populaire : chaque question rapporte par défaut dix points au joueur le plus rapide, et la victoire est attribuée au premier à franchir le seuil de cent points.

L'objectif n'est pas de reproduire PopSauce à l'identique, mais d'en proposer une version enrichie qui corrige plusieurs limites observées sur les plateformes existantes.

== Destinataires de l'application

L'application est destinée à un large public d'amateurs de jeux de connaissances et de rapidité. On distingue principalement :

- les *joueurs occasionnels*, qui rejoignent une partie publique ponctuellement, sans nécessairement créer de compte ;
- les *joueurs réguliers*, qui souhaitent suivre leurs statistiques et leur progression dans le temps ;
- les *communautés en ligne* (groupes d'amis, serveurs Discord, communautés de streaming) qui organisent des parties privées ;
- les *créateurs de contenu*, qui conçoivent et partagent leurs propres packs de questions.

== Délai attendu

L'application est attendue pour la fin de l'année académique 2025-2026 dans le cadre du travail de fin d'études. Le développement suivra une démarche itérative et incrémentale, permettant de livrer d'abord un noyau jouable (un mode de jeu fonctionnel en multijoueur), puis d'enrichir progressivement la plateforme avec les fonctionnalités secondaires (ajout de questions, modes de jeu additionnels, modèle économique, etc.).

== Justification de la demande et analyse concurrentielle

La demande est motivée par le constat que les plateformes de quiz rapides existantes restent peu abouties. Les principaux concurrents identifiés et les limites relevées sont les suivants :

#table(
  columns: (auto, 1fr),
  inset: 8pt,
  align: (left + horizon, left),
  table.header([*Concurrent*], [*Limites observées*]),
  [PopSauce],
  [Interface peu ergonomique et datée ; questions très orientées culture populaire, avec parfois un manque de cohérence ou de catégorisation.],

  [Kculture],
  [Modèle économique contraignant (abonnement à une chaîne Twitch) ; réponses validées par l'hôte en fin de partie plutôt qu'en temps réel ; catalogue de questions limité.],

  [Zequestion], [Plateforme peu connue ; absence de développement et d'animation autour du jeu.],
)

Ce panorama fait apparaître des marges d'amélioration claires : l'ergonomie, la richesse et la cohérence du contenu, la souplesse des règles de cotation, et un modèle économique mieux équilibré.

== Besoins fonctionnels

Le système doit répondre aux besoins fonctionnels suivants.

*Jeu multijoueur en temps réel.* Le cœur de l'application est la partie multijoueur synchrone : plusieurs joueurs réunis dans un même salon répondent simultanément à une série de questions, et un classement en direct reflète la rapidité et l'exactitude de leurs réponses. Le système doit gérer la création de salons publics et privés, la synchronisation des questions entre tous les participants et le décompte du temps.

*Modes de jeu variés.* Au-delà de la course au score classique, le système proposera plusieurs modes (par exemple : élimination progressive par système de vies, jeu en équipes, etc.). Chaque salon pourra choisir son mode au lancement de la partie. Le type de cotation sera également configurable : soit au temps, à la manière de PopSauce, soit par validation en fin de manche, à la manière de Kculture, cette seconde option offrant davantage de souplesse sur l'orthographe des réponses.

*Contenu mixte : officiel et communautaire.* Le catalogue de questions reposera sur deux sources. Un ensemble de packs *officiels* sera fourni et maintenu par l'auteur. En parallèle, les utilisateurs pourront créer et partager leurs propres *packs communautaires*. Pour garantir la qualité et la sécurité du contenu, ces contributions passeront par une file de modération avant publication, et un mécanisme de signalement permettra de remonter les contenus problématiques.

*Catégorisation des questions.* Les questions seront classées au moyen d'un système de tags fournis. Une assistance par intelligence artificielle pourra être envisagée pour suggérer automatiquement les catégories pertinentes lors de la création d'une question.

*Modération assistée.* La vérification des questions soumises par la communauté pourra elle aussi s'appuyer sur une assistance par intelligence artificielle, afin de présélectionner les contenus à valider et d'alléger le travail de l'administrateur.

*Profils et statistiques.* Les joueurs disposant d'un compte pourront consulter un profil personnel regroupant leur historique de parties et leurs statistiques (parties jouées, taux de bonnes réponses, temps de réponse moyen, packs favoris).

*Accès souple.* L'authentification ne sera pas obligatoire : un utilisateur pourra rejoindre une partie en tant qu'invité, sans inscription. La création d'un compte restera optionnelle et débloquera les fonctionnalités persistantes (profil, statistiques, création et sauvegarde de packs).

*Modèle économique.* Un nombre restreint de questions officielles (de l'ordre de vingt à quarante) sera accessible gratuitement chaque jour. Le créateur d'un salon pourra souscrire un abonnement donnant accès à l'intégralité du catalogue officiel. Afin d'éviter les doublons, certaines catégories sensibles (par exemple « deviner le pays ») seront réservées au contenu officiel et donc accessibles uniquement via l'abonnement, plutôt que reproduites dans les packs communautaires. Les abonnés bénéficieront en outre d'éléments cosmétiques (skins d'avatar, thèmes d'interface).

== Besoins non fonctionnels

- *Performance et équité* : le temps de réponse du système doit être suffisamment court pour préserver l'équité de la course à la rapidité, la latence ne devant pas avantager un joueur par rapport à un autre.
- *Ergonomie* : l'interface doit être soignée et agréable, en réponse directe au principal reproche fait aux plateformes concurrentes.
- *Compatibilité* : l'application doit rester utilisable confortablement sur les navigateurs web courants.
- *Évolutivité* : l'architecture doit permettre un portage ultérieur (mobile ou application de bureau) sans refonte majeure.
- *Sécurité et qualité du contenu* : le contenu communautaire doit être modéré avant publication et pouvoir être signalé après coup.

== Bénéfices attendus

Les bénéfices visés sont les suivants :

- une *expérience de jeu plus riche et rejouable*, grâce à la diversité des modes et au renouvellement permanent du contenu communautaire ;
- une *barrière d'entrée faible*, l'accès en mode invité permettant de jouer immédiatement ;
- une *fidélisation des joueurs*, par le suivi de leur progression et la reconnaissance de leurs contributions ;
- une *plateforme évolutive*, dont le catalogue s'enrichit par la communauté sans intervention constante de l'auteur ;
- un *modèle économique soutenable*, fondé sur l'abonnement et les éléments cosmétiques plutôt que sur la publicité intrusive.

== Périmètre du système

Le périmètre du système, pour cette première version, est le suivant :

- *Plateforme* : application *web* uniquement dans un premier temps. L'architecture sera néanmoins pensée pour permettre un portage ultérieur (mobile ou application de bureau) sans refonte majeure.
- *Portée fonctionnelle* : le système couvre l'ensemble de la chaîne de jeu (création de salon, déroulement d'une partie, classement), la gestion du contenu (création, catégorisation, modération, signalement), la gestion des profils ainsi que la gestion des abonnements.
- *Hors périmètre* : à ce stade, aucune fonctionnalité de réseau social avancé (messagerie privée, fil d'actualité) n'est prévue.

Trois acteurs sont identifiés à ce stade :

- le *Visiteur* : utilisateur non authentifié, qui peut rejoindre et jouer une partie en tant qu'invité. Il peut également créer et configurer un salon, mais de façon limitée (par exemple : pas d'accès aux questions officielles réservées à l'abonnement, pas de sauvegarde de la configuration du salon entre deux sessions) ;
- l'*Utilisateur authentifié* : il dispose de toutes les possibilités du visiteur, sans les limitations de ce dernier, auxquelles s'ajoutent le suivi de son profil et de ses statistiques ainsi que la soumission de questions à la communauté ;
- l'*Administrateur* : il gère la plateforme et valide (ou refuse) les questions soumises par les utilisateurs avant leur publication.

Ces rôles seront précisés et formalisés dans le diagramme de cas d'utilisation.

== Conditions d'utilisation et critères de réussite

L'objectif sera considéré comme atteint si le système satisfait les conditions suivantes :

- une partie multijoueur peut être lancée et menée à son terme par plusieurs joueurs simultanés sans désynchronisation perceptible ;
- un utilisateur peut rejoindre et jouer une partie en mode invité, sans inscription préalable ;
- un utilisateur peut soumettre un pack de questions, ce pack n'étant rendu jouable qu'après validation par la modération ;
- un joueur authentifié retrouve, d'une session à l'autre, son profil et ses statistiques à jour ;
- au moins deux modes de jeu distincts sont disponibles et fonctionnels ;
- les deux types de cotation (au temps et par validation en fin de manche) sont opérationnels.
