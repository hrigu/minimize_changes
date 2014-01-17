
%%% Der Streifen {p: 1, start_index: 5, end_index: 6} kommt auf den maschinen 1 - 6 genau einmal vor
constraint exactly(1,[
    bool2int((plan[1,5] == 1) /\ (plan[1,6] == 1)),
    bool2int((plan[2,5] == 1) /\ (plan[2,6] == 1)),
    bool2int((plan[3,5] == 1) /\ (plan[3,6] == 1)),
    ...
    bool2int((plan[6,5] == 1) /\ (plan[555,6] == 1))
], 1)


%%% Anzahl Streifen welche nicht unversehrt auf einer Maschine auftauchen minimieren
%%%
var 0...anzahl_streifen: end_anzahl_streifen_nicht_verteilt;
constraint end_anzahl_streifen_nicht_verteilt ==
    bool2int(!exists(m in MASCHINEN) ((plan[m,5] == 1) /\ (plan[m,6] == 1)));
    + bool2int(!exists(m in MASCHINEN) ((plan[m,1] == 4) /\ (plan[m,2] == 4)))
    + ...;



%%% Alternative Implementation zur Hilfstabelle um besser die Wechsel finden.
%	% etwas langsamer:
%	let  { var bool: a = (plan[m,t] == 0)}
%	in
%	(a /\ (plan_2[m,t] == plan_2[m,t-1]))
%	\/
%	(not(a) /\ (plan_2[m,t] == plan[m,t]))


%%% Anzahl Wechsel global. (Version Xa)
constraint end_wechsel ==
	% Übergänge 1->2, 2->1 und 2->2 betrachten. Nur erste zwei Arten der Übergänge zählen
	sum(m in MASCHINEN, t in 1..anzahl_time_slots-1) (
		bool2int(
			plan[m,t] != 0
			/\ plan[m,t+1] != 0
			/\ plan[m,t] != plan[m,t+1])
	)
	+
	% Übergänge x->0 betrachten, wobei x!=0
	sum(
		m in MASCHINEN,
		t1 in 1..anzahl_time_slots-2,
		t2 in t1+1..anzahl_time_slots-1
	) (
		bool2int(
			plan[m,t1] != 0
			/\ plan[m,t1+1] == 0
			/\ plan[m,t2] == 0
			/\ plan[m,t2+1] != 0
			/\ plan[m,t1] != plan[m,t2+1]
			/\ forall(t3 in t1+1..t2) (plan[m,t3] == 0)
		)
	);


