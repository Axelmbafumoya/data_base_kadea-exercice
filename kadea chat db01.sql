


-- =========================================================
-- 2. TABLE : UTILISATEURS
-- =========================================================

CREATE TABLE utilisateurs (
    id_utilisateur BIGSERIAL PRIMARY KEY,
    prenom VARCHAR(100) NOT NULL,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    mot_de_passe TEXT NOT NULL,
    avatar TEXT,
    date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 3. TABLE : CONVERSATIONS
-- =========================================================

CREATE TABLE conversations (
    id_conversation BIGSERIAL PRIMARY KEY,
    date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- =========================================================
-- 4. TABLE : PARTICIPATIONS
-- Relation entre utilisateurs et conversations
-- =========================================================

CREATE TABLE participations (
    id_utilisateur BIGINT NOT NULL,
    id_conversation BIGINT NOT NULL,
    date_adhesion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_utilisateur, id_conversation),

    CONSTRAINT fk_participation_utilisateur
        FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateurs(id_utilisateur)
        ON DELETE CASCADE,

    CONSTRAINT fk_participation_conversation
        FOREIGN KEY (id_conversation)
        REFERENCES conversations(id_conversation)
        ON DELETE CASCADE
);

-- =========================================================
-- 5. TABLE : MESSAGES
-- =========================================================

CREATE TABLE messages (
    id_message BIGSERIAL PRIMARY KEY,
    id_utilisateur BIGINT NOT NULL,
    id_conversation BIGINT NOT NULL,
    contenu TEXT NOT NULL,
    statut VARCHAR(20) NOT NULL DEFAULT 'sent',
    date_creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    date_modification TIMESTAMP,

    CONSTRAINT fk_message_utilisateur
        FOREIGN KEY (id_utilisateur)
        REFERENCES utilisateurs(id_utilisateur)
        ON DELETE CASCADE,

    CONSTRAINT fk_message_conversation
        FOREIGN KEY (id_conversation)
        REFERENCES conversations(id_conversation)
        ON DELETE CASCADE,

    CONSTRAINT check_statut_message
        CHECK (statut IN ('sent', 'delivered', 'read'))
);


INSERT INTO messages
(id_utilisateur, id_conversation, contenu, statut)
VALUES

-- Conversation 1
(1, 1, 'Salut Junior, comment vas-tu ?', 'read'), 
(2, 1, 'Salut Christian ! Je vais bien, merci.', 'read'),
(1, 1, 'Tu as terminé le projet Kadea Chat ?', 'delivered'),
(2, 1, 'Oui, je suis en train de finaliser la base de données.', 'sent'),

-- Conversation 2
(1, 2, 'Bonjour tout le monde !', 'read'),
(3, 2, 'Bonjour Christian !', 'read'),
(4, 2, 'Salut à tous.', 'read'),
(2, 2, 'On se retrouve cet après-midi pour travailler ?', 'delivered'),
(3, 2, 'Oui, je suis disponible.', 'sent'),

-- Conversation 3
(3, 3, 'Salut Grâce, tu as commencé le MCD ?', 'read'),
(5, 3, 'Oui, je viens de le terminer.', 'read'),
(3, 3, 'Super, on pourra comparer nos modèles.', 'sent');

-- =========================================================
-- 10. REQUÊTES DE TEST
-- =========================================================


-- ---------------------------------------------------------
-- Afficher tous les utilisateurs
-- ---------------------------------------------------------

SELECT *
FROM utilisateurs;


-- ---------------------------------------------------------
-- Afficher toutes les conversations
-- ---------------------------------------------------------

SELECT *
FROM conversations;

-- ---------------------------------------------------------
-- Afficher les participants de la conversation 2
-- ---------------------------------------------------------

SELECT
    u.id_utilisateur,
    u.prenom,
    u.nom,
    u.email
FROM utilisateurs u
JOIN participations p
    ON u.id_utilisateur = p.id_utilisateur
WHERE p.id_conversation = 2;

-- ---------------------------------------------------------
-- Afficher les messages de la conversation 1
-- ---------------------------------------------------------

SELECT *
FROM messages
WHERE id_conversation = 1
ORDER BY date_creation ASC;

-- ---------------------------------------------------------
-- Afficher les messages avec le nom de leur auteur
-- ---------------------------------------------------------

SELECT
    m.id_message,
    u.prenom,
    u.nom,
    m.contenu,
    m.statut,
    m.date_creation
FROM messages m
JOIN utilisateurs u
    ON m.id_utilisateur = u.id_utilisateur
ORDER BY m.date_creation ASC;

-- ---------------------------------------------------------
-- Afficher le dernier message de la conversation 1
-- ---------------------------------------------------------

SELECT
    m.id_message,
    u.prenom,
    u.nom,
    m.contenu,
    m.date_creation
FROM messages m
JOIN utilisateurs u
    ON m.id_utilisateur = u.id_utilisateur
WHERE m.id_conversation = 1
ORDER BY m.date_creation DESC
LIMIT 1;

-- ---------------------------------------------------------
-- Afficher les conversations de l'utilisateur 1
-- ---------------------------------------------------------

SELECT
    c.id_conversation,
    c.date_creation
FROM conversations c
JOIN participations p
    ON c.id_conversation = p.id_conversation
WHERE p.id_utilisateur = 1;

-- ---------------------------------------------------------
-- Rechercher un utilisateur par son email
-- ---------------------------------------------------------

SELECT *
FROM utilisateurs
WHERE email = 'junior.kabeya@kadea.com';

-- ---------------------------------------------------------
-- compter le nombre de messages d'une conversation ;
-- ---------------------------------------------------------

SELECT
    id_conversation,
    COUNT(*) AS nombre_messages
FROM messages
GROUP BY id_conversation
ORDER BY id_conversation;

-- ---------------------------------------------------------
-- Rechercher les messages envoyés par un utilisateur
-- ---------------------------------------------------------

SELECT
    id_message,
    id_conversation,
    contenu,
    statut,
    date_creation
FROM messages
WHERE id_utilisateur = 1
ORDER BY date_creation DESC;

