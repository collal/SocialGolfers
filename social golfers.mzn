%% 1.1 Modellazione

% Variabili: {Gruppi_ij | i ∈ [1, W], j ∈ [1,G]} dove Gruppi_ij è l'insieme di soci del j-esimo gruppo nel i-esimo settimana
  
% Domini: ∀i,j, Gruppi_ij ⊂ {1, .., P} 

% Vincoli: 
  % 1. Un soco può essere in un solo gruppo ogni settimana: 
      % ∀i ∈ [1,W],j1, j2 ∈ [1,G], j1 != j2, Gruppi[i,j1] ∩ Gruppi[i,j2] = {} 
  % 2. Ogni gruppo deve avere lo stesso numero di soci:
      % ∀i ∈ [1,W],j ∈ [1,G], |Gruppi[i,j]| = P / G
  % 3. Ogni coppia di soci gioca nello stesso gruppo al più una volta.
      % ∀i1, i2 ∈ [1,W], j1, j2 ∈ [1,G], |Gruppi[i1,j1] ∩ Gruppi[i2,j2]| <= 1


%% 1.2 Istanziazione: W = 4, G = 5, P = 20

% Variabili: {Gruppi_ij | i ∈ [1, 4], j ∈ [1,5]}
% Domini: ∀i,j Gruppi_ij ⊂ {1, .., 20} 
% Vincoli: 
    % Gruppi_11 ∩ Gruppi_12 = {}, Gruppi_11 ∩ Gruppi_13 = {}, ..., Gruppi_14 ∩ Gruppi_15 = {}, Gruppi21 ∩ Gruppi_12 = {}, ..., Gruppi44 ∩ Gruppi_45 = {}
    % |Gruppi_11| = 5, |Gruppi_12| = 5, ..., |Gruppi_45| = 5
    % |Gruppi_11 ∩ Gruppi_21| <= 1, |Gruppi_11 ∩ Gruppi_22| <= 1, |Gruppi_11 ∩ Gruppi_23| <= 1,... |Gruppi_35 ∩ Gruppi_45| <= 1
    
    

%% 1.3 Codificazione

int: G;
int: W;
int: P;
int: S = P div G;

constraint assert (
    (P div G) * G = P,
  "Error: num groups must divide num players for equally sized groups"
);

array [1..W, 1..G] of var set of 1..P: Gruppi;

include "globals.mzn";
constraint forall (i in 1..W, j1 in 1..G, j2 in (j1+1)..G) (disjoint (Gruppi[i, j1], Gruppi[i, j2])); % all_diff
constraint forall (i in 1..W, j in 1..G) (card(Gruppi[i,j]) = S); %force size of set
constraint forall (i1 in 1..W, i2 in (i1+1)..W, j1 in 1..G, j2 in 1..G) (card(Gruppi[i1, j1] intersect Gruppi[i2, j2]) <= 1); % socialites

solve satisfy;

output concat([ "Week (" ++ show(i) ++ "): \n" ++ concat(["Group (" ++ show(j) ++ "): " ++ show(Gruppi[i,j]) ++ "\n" | j in 1..G]) | i in 1..W]);



    