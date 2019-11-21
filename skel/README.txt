
**************************README**************************

========================Prefix AST========================


Student: Careja Alexandru-Cristian

Grupa: 314CD

Pentru rezolvarea temei am implementat 3 functii:
	1. solve care primeste ca argument adresa
nodului curent; Verifica daca nodul contine un
semn sau un numar. Daca este numar, atunci il
returneaza (in EAX), iar daca este operand va 
apela solve pe copii stanga respectiv dreapta si
va efectua operatia, returnand in EAX rezultatul 
acesteia.
	2. atoi primeste ca parametru adresa unui
string(sir de char-uri) si il parcurge char cu
char calculand cifra curenta ca si codul ascii al
char ului curent - 48(codul ascii pentru '0').
Formarea numarului se face inmultind la fiecare
pas EAX cu 10 si adaguand la EAX cifra curenta
(EAX este 0 la inceput). Totodata verifica si daca
primul caracter este '-' si inmulteste la final
numarul format cu -1. Rezultatul este returnat
in EAX.
	3. is_operation primeste ca parametru adresa
unui string si verifica daca este vreunul din
caracterele '-', '+', '/', '*' sufixat de '\0'
care are codul ascii 0. Daca stringul primit este
operand(+-*/), returneaza 1(in EDX). Altfel, 0.

Am preferat sa parcurg arborele in preordine cu
functia recursiva solve pentru o modularizare a
codului cat mai buna si pentru o rezolvare cat mai
logica. Am avut grija sa nu imi pierd valorile
importante din registrii la apelurile de functii
si am folosit stiva pentru a ma ajuta in acest
scop.
