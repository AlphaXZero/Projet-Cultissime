// ============================================================
//  Traduction C# du diagramme de classes — Projet Cultissime
//  (entités métier principales)
// ============================================================

// --- Énumérations ---
public enum Visibilité { Public, Privé }
public enum ModeJeu { CourseAuScore, Élimination, Équipes }
public enum TypeCotation { AuTemps, ValidationFinManche }
public enum StatutQuestion { EnAttente, Validée, Refusée }
public enum TypePack { Officiel, Communautaire }

// --- Classe abstraite de base : Joueur ---
public abstract class Joueur
{
    protected string Pseudo { get; set; }

    public abstract void RejoindreSalon(Salon s);
    public void SoumettreRéponse(Réponse r) { /* ... */ }
}

// --- Invité : un joueur non authentifié ---
public class Invité : Joueur
{
    public override void RejoindreSalon(Salon s) { /* ... */ }
    // Contrainte {Invité : pack->isEmpty()} : un invité ne possède aucun pack.
}

// --- Membre : hérite de Joueur, porte les données persistantes ---
public class Membre : Joueur
{
    private string Login { get; set; }
    private string Email { get; set; }
    private string MotDePasse { get; set; }
    private DateTime DateInscription { get; set; }

    // Statistiques fusionnées dans Membre
    public int PartiesJouées { get; set; }
    public float TauxBonnesRéponses { get; set; }
    public float TempsRéponseMoyen { get; set; }

    public Abonnement? Abonnement { get; set; }   // 0..1
    public List<Pack> PacksCréés { get; set; } = new();

    public override void RejoindreSalon(Salon s) { /* ... */ }
    public bool SAuthentifier(string login, string mdp) { /* ... */ return true; }
    public void SoumettreQuestion(Question q) { /* ... */ }
    public Abonnement Souscrire() { /* ... */ return new Abonnement(); }
}

// --- Question : avec attribut dérivé /score ---
public class Question
{
    public string Énoncé { get; set; }
    public StatutQuestion Statut { get; set; }
    public int VotesPositifs { get; set; }
    public int VotesNégatifs { get; set; }

    // Attribut dérivé : { score = votesPositifs - votesNégatifs }
    public int Score => VotesPositifs - VotesNégatifs;

    public List<Réponse> Réponses { get; set; } = new();   // 1..*
    public List<Média> Médias { get; set; } = new();        // 0..*
    public List<Tag> Tags { get; set; } = new();            // *..*

    public void AjouterVote(int valeur) { /* ... */ }
}

// --- Participation : classe d'association Joueur–Partie ---
public class Participation
{
    public Joueur Joueur { get; set; }
    public Partie Partie { get; set; }
    public int Score { get; set; }
    public int Rang { get; set; }
    public int Vies { get; set; }
}

// --- Vote : classe d'association Joueur–Question ---
public class Vote
{
    public Joueur Joueur { get; set; }
    public Question Question { get; set; }
    public int Valeur { get; set; }   // +1 ou -1
}