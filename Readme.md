# 🚢 Transportul subacvatic cu submarine comerciale
Bază de date pentru gestionarea rutelor, scufundărilor, pasagerilor și echipajelor dintr-un sistem de transport subacvatic comercial.

Proiect realizat pentru modelarea unui sistem complet de operare a scufundărilor comerciale cu submarine: rute, stații, itinerarii, echipaje și stagii.

---

## 📂 Structura bazei de date

### 🧱 Tabele

#### **1. Submarine_Type**
Stochează tipurile de submarine disponibile. Include:
- nume tip submarin  
- adâncime maximă  
- capacitate  

#### **2. Station**
Reprezintă stațiile subacvatice. Include:
- nume  
- regiune  
- adâncime  

#### **3. Route**
Definește rutele între două stații. Include:
- stație origine / destinație  
- distanță  
- preț de bază  
- tipul de submarin compatibil  
- verificare stații diferite  

#### **4. Scheduled_Dive**
Scufundări programate pe o rută. Include:
- ore plecare / sosire  
- locuri disponibile  
- nivel presiune  
- verificare ordine temporală  

#### **5. Passenger**
Informații despre pasageri:
- nume  
- email  
- nivel aprobare medicală  

#### **6. Itinerary**
Itinerariul unui pasager:
- data creării  
- preț total  

#### **7. Itinerary_Segment**
Segmentele unui itinerariu:
- dive asociat  
- ordinea segmentului  
- locul ocupat  
- unicitate segment în itinerariu  

#### **8. Crew_Member**
Membrii echipajului:
- nume  
- certificare  
- ani experiență  

#### **9. Captain**
Specializare pentru căpitani:
- nivel comandă  

#### **10. Engineer**
Specializare pentru ingineri:
- domeniu tehnic  

#### **11. Medic**
Specializare pentru personal medical:
- specializare medicală  
- nivel pregătire urgențe  

#### **12. Dive_Crew**
Asociere scufundare–echipaj:
- rolul membrului în scufundare  

#### **13. Internship**
Stagii pentru pasageri alături de echipaj:
- nivel training  
- feedback (1–10)  

---

## 👁️ View-uri definite

### **Dive_Details**
Listă completă a scufundărilor programate, cu detalii despre:
- rută  
- stații  
- distanță  
- preț  

### **Passenger_Itineraries**
Itinerarii complete ale pasagerilor, cu segmente și scufundări.

### **Dive_Crew_View**
Echipajul fiecărei scufundări, cu rolurile membrilor.

### **Internship_Details**
Detalii despre stagii:
- pasager  
- membru echipaj  
- scufundare  
- nivel training  
- feedback  

### **Dive_Calculated_Info**
Include o coloană calculată:
- durata scufundării  
- preț pe minut  

---

## 🔎 Selecturi realizate pe view-uri

- Scufundări ordonate după durata calculată  
- Cele mai scumpe scufundări (preț/minut)  
- Pasageri cu mai multe segmente în itinerariu  
- Echipaje cu roluri specifice  
- Stagii cu feedback mare  
- Rute lungi cu detalii despre stații  

---

## 🧱 Materialized View

### **mv_route_statistics**
Statistici agregate pentru fiecare rută:
- număr scufundări  
- durata medie  
- locuri libere medii  

### Select realizat:
- calcul scor eficiență (viteză) + clasificare rute  

---

## ✨ Autor
Petcu Ionuț-Octavian  
FMI – Universitatea din București
