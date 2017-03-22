
;;;======================================================
;;;   INGENIERIA Y GESTIÓN DEL CONOCIMIENTO
;;;   Curso 2015/16
;;;   Primera Actividad Evaluable
;;;
;;;   Alumno: José Luis Pérez González
;;;   DNI: 
;;;
;;;      Sistema Experto que elabora una dieta semanal en
;;;      función de las características y necesidades del
;;;      usuario que lo opera.
;;;      Tiene en cuenta las necesidades calóricas del
;;;      usuario, la aportación necesaria de cada macro-
;;;      nutriente, y el número de raciones diarias reco-
;;;      mendadas de cada grupo de alimentos.
;;;
;;;   Para ejecutarlo:
;;;      (load "dieta.clp")
;;;      (reset)
;;;      (run)
;;;;======================================================


;;;=======================================================
;;;   BASE DE HECHOS
;;;=======================================================

(deftemplate alimento "Plantilla que describe los datos necesarios de cada alimento a utilizar"
	(slot id (type INTEGER) (range 1 ?VARIABLE))
	(slot grupo (type INTEGER) (range 1 7))
	(slot nombre (type STRING))
	(slot kcal (type INTEGER) (range 1 ?VARIABLE))			; kcal por cada 100 gramos
	(slot proteinas (type FLOAT) (range 0.0 ?VARIABLE))		; gramos por cada 100 gramos
	(slot hidratos (type FLOAT) (range 0.0 ?VARIABLE))		; gramos por cada 100 gramos
	(slot grasas (type FLOAT) (range 0.0 ?VARIABLE))		; gramos por cada 100 gramos
	(slot racion-minima (type INTEGER) (range 1 ?VARIABLE)) ; en gramos
	(slot racion-maxima (type INTEGER) (range 1 ?VARIABLE)) ; en gramos
	(multislot indicado-para (type SYMBOL) (allowed-symbols Desayuno Almuerzo Comida Merienda Cena Postre))
	(slot acom (type SYMBOL) (allowed-symbols TRUE FALSE) (default FALSE))) ; Alimentos que sirven para acompañar a otros

(deffacts alimentos-grupo-1 "Alimentos del grupo 1: Leche y derivados"
	(alimento
		(id 1) (grupo 1) (nombre "Leche Entera") (kcal 63) (proteinas 3.2) (hidratos 4.6) (grasas 3.7) (racion-minima 100) (racion-maxima 300) (indicado-para Desayuno))
	(alimento
		 (id 2) (grupo 1) (nombre "Yogur Entero") (kcal 61) (proteinas 3.3) (hidratos 4.0) (grasas 3.5) (racion-minima 125) (racion-maxima 125) (indicado-para Desayuno Postre))
	(alimento
		(id 3) (grupo 1) (nombre "Yogur con Frutas") (kcal 89) (proteinas 2.8) (hidratos 12.6) (grasas 3.3) (racion-minima 125) (racion-maxima 125) (indicado-para Desayuno Postre))
	(alimento
		(id 4) (grupo 1) (nombre "Queso Brie") (kcal 263) (proteinas 17.0) (hidratos 1.67) (grasas 21.0) (racion-minima 40) (racion-maxima 60) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 5) (grupo 1) (nombre "Queso Philadelphia") (kcal 200) (proteinas 10.0) (hidratos 6.6) (grasas 16.6) (racion-minima 40) (racion-maxima 60) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 6) (grupo 1) (nombre "Requesón") (kcal 96) (proteinas 13.6) (hidratos 1.4) (grasas 4.0) (racion-minima 85) (racion-maxima 85) (indicado-para Postre))
	(alimento
		(id 7) (grupo 1) (nombre "Queso Parmesano") (kcal 374) (proteinas 36.0) (hidratos 0.0) (grasas 25.6) (racion-minima 40) (racion-maxima 60) (indicado-para Merienda Postre))
	(alimento
		(id 8) (grupo 1) (nombre "Helado de Crema") (kcal 167) (proteinas 2.8) (hidratos 20.0) (grasas 8.4) (racion-minima 75) (racion-maxima 120) (indicado-para Postre))
	(alimento
		(id 9) (grupo 1) (nombre "Flan de Huevo") (kcal 126) (proteinas 4.8) (hidratos 20.0) (grasas 2.9) (racion-minima 85) (racion-maxima 85) (indicado-para Postre))
	(alimento
		(id 10) (grupo 1) (nombre "Cuajada") (kcal 86) (proteinas 4.5) (hidratos 6.5) (grasas 4.7) (racion-minima 85) (racion-maxima 85) (indicado-para Postre Merienda)))

(deffacts alimentos-grupo-2 "Alimentos del grupo 2: Carne, huevos y pescado"
	(alimento
		(id 11) (grupo 2) (nombre "Huevo Hervido") (kcal 147) (proteinas 12.3) (hidratos 0.2) (grasas 10.9) (racion-minima 60) (racion-maxima 60) (indicado-para Desayuno Almuerzo Comida Cena))
	(alimento
		(id 12) (grupo 2) (nombre "Huevo Frito") (kcal 232) (proteinas 14.0) (hidratos 0.2) (grasas 20.0) (racion-minima 60) (racion-maxima 60) (indicado-para Comida Cena))
	(alimento
		(id 13) (grupo 2) (nombre "Bistec de Ternera") (kcal 92) (proteinas 20.7) (hidratos 0.5) (grasas 1.0) (racion-minima 120) (racion-maxima 160) (indicado-para Comida Cena))
	(alimento
		(id 14) (grupo 2) (nombre "Solomillo de Cerdo") (kcal 158) (proteinas 22.3) (hidratos 0.0) (grasas 7.6) (racion-minima 120) (racion-maxima 160) (indicado-para Comida Cena))
	(alimento
		(id 15) (grupo 2) (nombre "Pechuga de Pollo") (kcal 134) (proteinas 22.0) (hidratos 0.4) (grasas 4.9) (racion-minima 120) (racion-maxima 160) (indicado-para Comida Cena))
	(alimento
		(id 16) (grupo 2) (nombre "Hamburguesa") (kcal 230) (proteinas 14.0) (hidratos 0.5) (grasas 18.3) (racion-minima 100) (racion-maxima 130) (indicado-para Comida Cena))
	(alimento
		(id 18) (grupo 2) (nombre "Bacalao") (kcal 122) (proteinas 29.0) (hidratos 0.0) (grasas 0.7) (racion-minima 125) (racion-maxima 200) (indicado-para Comida Cena))
	(alimento
		(id 19) (grupo 2) (nombre "Dorada") (kcal 80) (proteinas 19.8) (hidratos 0.0) (grasas 1.2) (racion-minima 125) (racion-maxima 200) (indicado-para Comida Cena))
	(alimento
		(id 20) (grupo 2) (nombre "Salmón") (kcal 176) (proteinas 18.4) (hidratos 0.0) (grasas 12.0) (racion-minima 125) (racion-maxima 200) (indicado-para Comida Cena))
	(alimento
		(id 21) (grupo 2) (nombre "Sepia") (kcal 73) (proteinas 14.0) (hidratos 0.7) (grasas 1.5) (racion-minima 125) (racion-maxima 200) (indicado-para Comida Cena)))

(deffacts alimentos-grupo-3 "Alimentos del grupo 3: Patatas, legumbres y frutos secos"
	(alimento
		(id 22) (grupo 3) (nombre "Guiso Judías Blancas") (kcal 109) (proteinas 4.0) (hidratos 11.0) (grasas 5.0) (racion-minima 60) (racion-maxima 90) (indicado-para Comida))
	(alimento
		(id 23) (grupo 3) (nombre "Garbanzos Cocidos") (kcal 90) (proteinas 4.0) (hidratos 10.0) (grasas 3.4) (racion-minima 60) (racion-maxima 90) (indicado-para Comida))
	(alimento
		(id 24) (grupo 3) (nombre "Lentejas Guisadas") (kcal 120) (proteinas 4.0) (hidratos 11.0) (grasas 5.0) (racion-minima 60) (racion-maxima 90) (indicado-para Comida))
	(alimento
		(id 26) (grupo 3) (nombre "Almendras") (kcal 499) (proteinas 16.0) (hidratos 22.0) (grasas 51.4) (racion-minima 20) (racion-maxima 40) (indicado-para Almuerzo Merienda))
	(alimento
		(id 27) (grupo 3) (nombre "Avellanas") (kcal 625) (proteinas 13.0) (hidratos 10.0) (grasas 62.9) (racion-minima 20) (racion-maxima 40) (indicado-para Almuerzo Merienda))
	(alimento
		(id 28) (grupo 3) (nombre "Pistachos") (kcal 600) (proteinas 21.0) (hidratos 28.0) (grasas 48.0) (racion-minima 20) (racion-maxima 40) (indicado-para Almuerzo Merienda))
	(alimento
		(id 29) (grupo 3) (nombre "Nueces") (kcal 670) (proteinas 15.6) (hidratos 11.2) (grasas 63.3) (racion-minima 20) (racion-maxima 40) (indicado-para Almuerzo Merienda))
	(alimento
		(id 30) (grupo 3) (nombre "Patatas Fritas") (kcal 234) (proteinas 3.6) (hidratos 34.0) (grasas 11.0) (racion-minima 50) (racion-maxima 150) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 31) (grupo 3) (nombre "Patatas Cocidas") (kcal 77) (proteinas 1.7) (hidratos 16.0) (grasas 0.2) (racion-minima 50) (racion-maxima 150) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 32) (grupo 3) (nombre "Puré de Patatas") (kcal 350) (proteinas 8.2) (hidratos 75.0) (grasas 0.8) (racion-minima 60) (racion-maxima 90) (indicado-para Comida Cena) (acom TRUE)))

(deffacts alimentos-grupo-4 "Alimentos del grupo 4: Verduras y hortalizas"
	(alimento
		(id 33) (grupo 4) (nombre "Lechuga") (kcal 20) (proteinas 1.3) (hidratos 1.5) (grasas 0.5) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 34) (grupo 4) (nombre "Acelgas") (kcal 25) (proteinas 2.4) (hidratos 4.6) (grasas 0.3) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom FALSE))
	(alimento
		(id 35) (grupo 4) (nombre "Apio") (kcal 22) (proteinas 2.3) (hidratos 2.4) (grasas 0.2) (racion-minima 150) (racion-maxima 250) (indicado-para Almuerzo Comida Cena) (acom TRUE))
	(alimento
		(id 36) (grupo 4) (nombre "Berenjena") (kcal 16) (proteinas 1.1) (hidratos 2.6) (grasas 0.1) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom FALSE))
	(alimento
		(id 37) (grupo 4) (nombre "Calabacín") (kcal 12) (proteinas 1.3) (hidratos 1.4) (grasas 0.1) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 38) (grupo 4) (nombre "Coliflor") (kcal 25) (proteinas 3.2) (hidratos 2.7) (grasas 0.2) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 39) (grupo 4) (nombre "Espinacas") (kcal 31) (proteinas 3.4) (hidratos 3.0) (grasas 0.7) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom FALSE))
	(alimento
		(id 40) (grupo 4) (nombre "Tomates") (kcal 16) (proteinas 1.0) (hidratos 2.9) (grasas 0.2) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 41) (grupo 4) (nombre "Puerros") (kcal 26) (proteinas 2.1) (hidratos 6.0) (grasas 0.1) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 42) (grupo 4) (nombre "Endivias") (kcal 20) (proteinas 1.7) (hidratos 4.1) (grasas 0.1) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 69) (grupo 4) (nombre "Repollo") (kcal 25) (proteinas 1.3) (hidratos 6.0) (grasas 0.1) (racion-minima 150) (racion-maxima 250) (indicado-para Comida Cena) (acom FALSE)))

(deffacts alimentos-grupo-5 "Alimentos del grupo 5: Frutas"
	(alimento
		(id 43) (grupo 5) (nombre "Kiwi") (kcal 53) (proteinas 0.8) (hidratos 10.8) (grasas 0.6) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 44) (grupo 5) (nombre "Manzana") (kcal 45) (proteinas 0.2) (hidratos 10.4) (grasas 0.3) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 45) (grupo 5) (nombre "Melón") (kcal 30) (proteinas 0.8) (hidratos 7.4) (grasas 0.2) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 46) (grupo 5) (nombre "Naranja") (kcal 53) (proteinas 1.0) (hidratos 11.7) (grasas 0.2) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 47) (grupo 5) (nombre "Pera") (kcal 58) (proteinas 0.7) (hidratos 15.0) (grasas 0.1) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 48) (grupo 5) (nombre "Plátano") (kcal 85) (proteinas 1.2) (hidratos 19.5) (grasas 0.3) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 49) (grupo 5) (nombre "Pomelo") (kcal 26) (proteinas 0.6) (hidratos 6.2) (grasas 0.0) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 50) (grupo 5) (nombre "Sandía") (kcal 15) (proteinas 0.7) (hidratos 3.7) (grasas 0.0) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 51) (grupo 5) (nombre "Uvas") (kcal 61) (proteinas 0.5) (hidratos 15.6) (grasas 0.1) (racion-minima 150) (racion-maxima 200) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 52) (grupo 5) (nombre "Fresas") (kcal 27) (proteinas 0.9) (hidratos 5.6) (grasas 0.4) (racion-minima 150) (racion-maxima 200) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 67) (grupo 5) (nombre "Membrillo") (kcal 57) (proteinas 0.4) (hidratos 15.0) (grasas 0.1) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre))
	(alimento
		(id 68) (grupo 5) (nombre "Níspero") (kcal 47) (proteinas 0.4) (hidratos 12.0) (grasas 0.2) (racion-minima 150) (racion-maxima 150) (indicado-para Desayuno Almuerzo Merienda Postre)))

(deffacts alimentos-grupo-6 "Alimentos del grupo 6: Pan, pasta, cereales, azúcar y dulces"
	(alimento
		(id 53) (grupo 6) (nombre "Galleta tipo María") (kcal 409) (proteinas 6.8) (hidratos 82.3) (grasas 8.1) (racion-minima 30) (racion-maxima 60) (indicado-para Desayuno))
	(alimento
		(id 54) (grupo 6) (nombre "Pan tostado") (kcal 420) (proteinas 11.3) (hidratos 83.0) (grasas 6.0) (racion-minima 30) (racion-maxima 60) (indicado-para Desayuno Almuerzo))
	(alimento
		(id 55) (grupo 6) (nombre "Ñoquis") (kcal 246) (proteinas 6.3) (hidratos 40.2) (grasas 6.6) (racion-minima 80) (racion-maxima 100) (indicado-para Comida Cena))
	(alimento
		(id 56) (grupo 6) (nombre "Raviolis") (kcal 253) (proteinas 9.1) (hidratos 44.4) (grasas 4.4) (racion-minima 80) (racion-maxima 100) (indicado-para Comida Cena))
	(alimento
		(id 57) (grupo 6) (nombre "Tallarines") (kcal 287) (proteinas 9.2) (hidratos 56.8) (grasas 2.6) (racion-minima 80) (racion-maxima 100) (indicado-para Comida Cena))
	(alimento
		(id 58) (grupo 6) (nombre "Mermelada") (kcal 272) (proteinas 0.6) (hidratos 70.0) (grasas 0.1) (racion-minima 15) (racion-maxima 30) (indicado-para Desayuno))
	(alimento
		(id 59) (grupo 6) (nombre "Miel") (kcal 300) (proteinas 0.6) (hidratos 80.0) (grasas 0.0) (racion-minima 10) (racion-maxima 20) (indicado-para Desayuno))
	(alimento
		(id 60) (grupo 6) (nombre "Chocolate con leche") (kcal 542) (proteinas 6.0) (hidratos 54.0) (grasas 33.5) (racion-minima 30) (racion-maxima 70) (indicado-para Almuerzo Merienda))
	(alimento
		(id 61) (grupo 6) (nombre "Churros") (kcal 348) (proteinas 4.6) (hidratos 40.0) (grasas 20.0) (racion-minima 10) (racion-maxima 30) (indicado-para Desayuno))
	(alimento
		(id 62) (grupo 6) (nombre "Donuts") (kcal 391) (proteinas 4.6) (hidratos 51.4) (grasas 18.6) (racion-minima 50) (racion-maxima 50) (indicado-para Desayuno Almuerzo Merienda))
	(alimento
		(id 63) (grupo 6) (nombre "Magdalenas") (kcal 391) (proteinas 5.3) (hidratos 48.4) (grasas 18.4) (racion-minima 50) (racion-maxima 50) (indicado-para Desayuno))
	(alimento
		(id 64) (grupo 6) (nombre "Arroz cocido") (kcal 123) (proteinas 2.2) (hidratos 27.9) (grasas 0.6) (racion-minima 80) (racion-maxima 100) (indicado-para Comida Cena) (acom TRUE))
	(alimento
		(id 65) (grupo 6) (nombre "Pan Blanco") (kcal 270) (proteinas 8.1) (hidratos 64.0) (grasas 0.5) (racion-minima 60) (racion-maxima 100) (indicado-para Comida Merienda Cena) (acom TRUE))
	(alimento
		(id 66) (grupo 6) (nombre "Pan Integral") (kcal 230) (proteinas 9.0) (hidratos 47.5) (grasas 1.0) (racion-minima 60) (racion-maxima 100) (indicado-para Comida Merienda Cena) (acom TRUE)))

(deftemplate registro-calorico "Lleva la cuenta de las calorías diarias aportadas por cada alimento consumido"
	(slot dia (type SYMBOL) (allowed-symbols lunes martes miercoles jueves viernes))
	(slot cal (type FLOAT) (range 0.0 ?VARIABLE)))

(deffacts registro "Inicialización de registro calórico"
	(registro-calorico (dia lunes) (cal 0.0))
	(registro-calorico (dia martes) (cal 0.0))
	(registro-calorico (dia miercoles) (cal 0.0))
	(registro-calorico (dia jueves) (cal 0.0))
	(registro-calorico (dia viernes) (cal 0.0)))

(deftemplate registro-macro "Lleva la cuenta semanal de las calorías aportadas por cada macronutriente"
	(slot hidratos (type FLOAT) (range 0.0 ?VARIABLE))
	(slot proteinas (type FLOAT) (range 0.0 ?VARIABLE))
	(slot grasas (type FLOAT) (range 0.0 ?VARIABLE)))

(deffacts registro-macro "Inicialización registro macronutrientes"
	(registro-macro (hidratos 0.0) (proteinas 0.0) (grasas 0.0)))

(deftemplate raciones-por-grupo "Raciones diarias para cada grupo de alimentos"
	(slot grupo (type INTEGER) (range 1 6))
	(slot raciones (type INTEGER) (range 0 ?VARIABLE)))

(deffacts raciones "Establecimiento de las raciones diarias necesarias de cada grupo de alimentos"
	; Los grupos 3 y 6 aportan conjuntamente.
	(raciones-por-grupo (grupo 1) (raciones 3)) ; Leche y derivados
	(raciones-por-grupo (grupo 2) (raciones 3)) ; Carne, huevos y pescado
	(raciones-por-grupo (grupo 3) (raciones 5)) ; Patatas, legumbres y frutos secos
	(raciones-por-grupo (grupo 4) (raciones 4)) ; Verduras y hortalizas
	(raciones-por-grupo (grupo 5) (raciones 3)) ; Frutas
	(raciones-por-grupo (grupo 6) (raciones 5))); Pan, pasta, cereales, azúcar y dulces

(deftemplate menu "Lista de alimentos añadidos al menu diario"
	(slot dia (type SYMBOL) (allowed-symbols lunes martes miercoles jueves viernes))
	(slot comida (type SYMBOL) (allowed-symbols Desayuno Almuerzo Comida Merienda Cena))
	(multislot alimentos (type INTEGER)))

(deffacts menus "Inicialización menús diarios"
	(menu (dia lunes) (comida Desayuno))
	(menu (dia lunes) (comida Almuerzo))
	(menu (dia lunes) (comida Comida))
	(menu (dia lunes) (comida Merienda))
	(menu (dia lunes) (comida Cena))
	(menu (dia martes) (comida Desayuno))
	(menu (dia martes) (comida Almuerzo))
	(menu (dia martes) (comida Comida))
	(menu (dia martes) (comida Merienda))
	(menu (dia martes) (comida Cena))
	(menu (dia miercoles) (comida Desayuno))
	(menu (dia miercoles) (comida Almuerzo))
	(menu (dia miercoles) (comida Comida))
	(menu (dia miercoles) (comida Merienda))
	(menu (dia miercoles) (comida Cena))
	(menu (dia jueves) (comida Desayuno))
	(menu (dia jueves) (comida Almuerzo))
	(menu (dia jueves) (comida Comida))
	(menu (dia jueves) (comida Merienda))
	(menu (dia jueves) (comida Cena))
	(menu (dia viernes) (comida Desayuno))
	(menu (dia viernes) (comida Almuerzo))
	(menu (dia viernes) (comida Comida))
	(menu (dia viernes) (comida Merienda))
	(menu (dia viernes) (comida Cena)))

(deftemplate alimentos-posibles "Guarda la lista de ids de los alimentos que se pueden añadir en una búsqueda determinada"
	(multislot ids (type INTEGER) (range 0 ?VARIABLE)))

(deffacts posibles "Inicialización de alimentos posibles"
	(alimentos-posibles (ids)))

(deftemplate necesidades-cal "Necesidades calóricas para cada comida del día"
	(slot comida (type SYMBOL) (allowed-symbols Desayuno Almuerzo Comida Merienda Cena))
	(slot cal (type FLOAT)))

(deftemplate necesidades-macro "Necesidades diarias de macronutrientes"
	(slot dia (type SYMBOL) (allowed-symbols lunes martes miercoles jueves viernes))
	(slot hidratos (type FLOAT))
	(slot proteinas (type FLOAT))
	(slot grasas (type FLOAT)))

(deftemplate gasto-por-actividad "Gasto calórico fijo en función de la actividad física"
	(slot tipo-actividad (type SYMBOL) (allowed-symbols r l m i))
	(slot gasto-actividad (type INTEGER)))

(deftemplate rango-gasto-energetico "Gasto calórico en función de las características físicas del usuario"
	(slot genero (type SYMBOL) (allowed-symbols h m))
	(slot edad-minima (type INTEGER))
	(slot edad-maxima (type INTEGER))
	(slot factor (type FLOAT))
	(slot fijo (type INTEGER)))

(deftemplate tipo-dieta "Gasto calórico en función del tipo de dieta requerida (perder o mantener)"
	(slot tipo (type SYMBOL) (allowed-symbols p m))
	(slot factor (type FLOAT)))

; Añade hechos iniciales para las tres plantillas anteriores
(deffacts tabla-gasto-energetico "Inicialización necesidades calóricas"
	; Necesidades calóricas en función del género y la edad
	(rango-gasto-energetico
		(genero h) (edad-minima 0) (edad-maxima 3) (factor 60.9) (fijo -54))
	(rango-gasto-energetico
		(genero h) (edad-minima 3) (edad-maxima 10) (factor 22.7) (fijo 495))
	(rango-gasto-energetico
		(genero h) (edad-minima 10) (edad-maxima 18) (factor 17.5) (fijo 651))
	(rango-gasto-energetico
		(genero h) (edad-minima 18) (edad-maxima 30) (factor 15.3) (fijo 679))
	(rango-gasto-energetico
		(genero h) (edad-minima 30) (edad-maxima 60) (factor 11.6) (fijo 879))
	(rango-gasto-energetico
		(genero h) (edad-minima 60) (edad-maxima 1000) (factor 13.5) (fijo 487))
	(rango-gasto-energetico
		(genero m) (edad-minima 0) (edad-maxima 3) (factor 61.0) (fijo -51))
	(rango-gasto-energetico
		(genero m) (edad-minima 3) (edad-maxima 10) (factor 22.5) (fijo 499))
	(rango-gasto-energetico
		(genero m) (edad-minima 10) (edad-maxima 18) (factor 12.2) (fijo 746))
	(rango-gasto-energetico
		(genero m) (edad-minima 18) (edad-maxima 30) (factor 14.7) (fijo 496))
	(rango-gasto-energetico
		(genero m) (edad-minima 30) (edad-maxima 60) (factor 8.7) (fijo 829))
	(rango-gasto-energetico
		(genero m) (edad-minima 60) (edad-maxima 1000) (factor 10.5) (fijo 596))
	; Necesidades calóricas en función de la actividad física
	(gasto-por-actividad
		(tipo-actividad r) (gasto-actividad 0))
	(gasto-por-actividad
		(tipo-actividad l) (gasto-actividad 200))	
	(gasto-por-actividad
		(tipo-actividad m) (gasto-actividad 400))	
	(gasto-por-actividad
		(tipo-actividad i) (gasto-actividad 1000))
	; Necesidades calóricas en función del tipo de dieta (perder o manetener)
	(tipo-dieta
		(tipo p) (factor 0.9))
	(tipo-dieta
		(tipo m) (factor 1.0)))

; Estos hechos los necesitan varias reglas para saber qué
; día/comida son el/la siguiente.
(deffacts dias-comidas "Días de la semana y comidas del día"
	(dias lunes martes miercoles jueves viernes)
	(comidas Desayuno Almuerzo Comida Merienda Cena)
)


;;;=======================================================
;;;   BASE DE CONOCIMIENTO
;;;      1. Hechos desconocidos (preguntar al usuario)
;;;      2. Calcular necesidades calóricas
;;;      3. Confeccionar el menú
;;;      4. Imprimir resultados
;;;=======================================================


;;;**************************
;;;* 1. Hechos desconocidos *
;;;**************************

(defrule pregunta-nombre "Regla de entrada, comenzamos por preguntar el nombre del usuario"
	=>
	(printout t "¿Cómo te llamas? ")
	(bind ?nombre (readline))
	(assert (nombre-usuario ?nombre)))

(defrule pregunta-edad "Preguntar edad del usuario"
	(nombre-usuario $?)
	=>
	(printout t "¿Cuántos años tienes? ")
	(bind ?edad (read))
	(assert (edad-usuario ?edad)))

(defrule pregunta-genero "Preguntar género del usuario"
	(edad-usuario ?)
	=>
	(printout t "¿Eres (h)ombre o (m)ujer? ")
	(bind ?genero (read))
	(assert (genero-usuario ?genero)))

(defrule pregunta-peso "Preguntar peso del usuario"
	(genero-usuario ?)
	=>
	(printout t "¿Cuánto pesas? (en kg): ")
	(bind ?peso (read))
	(assert (peso-usuario ?peso)))

(defrule pregunta-actividad "Preguntar qué tipo de actividad física realiza el usuario"
	(peso-usuario ?)
	=>
	(printout t "¿Qué tipo de actividad física llevas en tu vida diaria? (r)eposo, (l)igera, (m)oderada o (i)ntensa: ")
	(bind ?actividad (read))
	(assert (actividad-usuario ?actividad)))

(defrule pregunta-dieta "Preguntar si el usuario quiere (p)erder o (m)antener peso"
	(actividad-usuario ?)
	=>
	(printout t "¿Quieres (p)erder o (m)antener peso? ")
	(bind ?dieta (read))
	(assert (dieta-usuario ?dieta)))


;;;*************************************
;;;* 2. Calcular necesidades calóricas *
;;;*************************************

; Calorías necesarias = Gasto energético basal + gasto energético por actividad física
; Gasto energético basal => Hechos en "tabla-gasto-energético"
(defrule calcula-calorias "Obtener las necesidades calóricas particulares del usuario"
	(edad-usuario ?edad)
	(genero-usuario ?genero)
	(peso-usuario ?peso)
	(actividad-usuario ?actividad)
	(dieta-usuario ?dieta)
	(rango-gasto-energetico
		(genero ?genero)
		(edad-minima ?edad-minima&:(<= ?edad-minima ?edad))
		(edad-maxima ?edad-maxima&:(> ?edad-maxima ?edad))
		(factor ?factor) ; factor en función de la edad y el género a multiplicar por el peso
		(fijo ?fijo))    ; gasto fijo en función de la edad y el género
	(gasto-por-actividad (tipo-actividad ?actividad) (gasto-actividad ?gasto-actividad))
	(tipo-dieta (tipo ?dieta) (factor ?factor-tipo-dieta)) ; factor multiplicativo (0.9 si perder, 1 si mantener)
	=>
	(bind ?gasto (* (+ (* ?factor ?peso) ?fijo ?gasto-actividad) ?factor-tipo-dieta))
	(assert (gasto-energetico ?gasto))
	(assert (fase buscar FALSE Desayuno lunes))) ; FALSE porque no empezamos buscando un plato para comida o cena

; Asumimos que cada comida debe aportar un porcentaje determinado
; de las necesidades calóricas diarias.
;    Desayuno: 20%
;    Almuerzo: 15%
;    Comida: 30%
;    Merienda: 15%
;    Cena: 20%
(defrule division-cal-por-comida "Necesidades calóricas para cada comida del día"
	(gasto-energetico ?gasto)
	=>
	(assert (necesidades-cal (comida Desayuno) (cal (* ?gasto 0.2))))
	(assert (necesidades-cal (comida Almuerzo) (cal (* ?gasto 0.15))))
	(assert (necesidades-cal (comida Comida) (cal (* ?gasto 0.3))))
	(assert (necesidades-cal (comida Merienda) (cal (* ?gasto 0.15))))
	(assert (necesidades-cal (comida Cena) (cal (* ?gasto 0.2))))
)

; Definimos que diariamente, cada macronutriente deberá aportar
; una cantidad máxima de calorías.
;    Hidratos de carbono: 50% del total de calorías
;    Proteinas: 15% del total de calorías
;    Grasas: 35% del total de calorías
(defrule calcula-macro-nutrientes "Necesidades calóricas diarias de cada uno de los tres macronutrientes"
	(gasto-energetico ?gasto)
	(dias $? ?dia $?)
	=>
	(assert (necesidades-macro (dia ?dia) (hidratos (* ?gasto 0.50))
										  (proteinas (* ?gasto 0.15))
										  (grasas (* ?gasto 0.35)))))


;;;****************************************************************
;;;* 3. Confeccionar el menú                                      *
;;;*    Dos casos diferentes:                                     *
;;;*      a) Buscar alimentos para desayuno, almuerzo o merienda  *
;;;*      b) Buscar alimentos para comida o cena                  *
;;;*                                                              *
;;;*    El caso a) consiste simplemente en buscar un alimento     *
;;;*    cumpla con las restricciones (calóricas, macronutrientes, *
;;;*    grupo de alimentos) impuestas.                            *
;;;*    En el caso b) se buscan 3 alimentos conjuntamente. Uno    *
;;;*    para el plato principal, otro para la guarnición, y el    *
;;;*    último para el postre. Igualmente, cada uno de ellos por  *
;;;*    separado debe cumplir las restricciones.                  *
;;;****************************************************************

; Busca todos los alimentos y los añade a la lista de alimentos posibles
; Dispara regla "elegir-alimento"
(defrule buscar-alimentos "Buscar un alimento que cumpla con las restricciones calóricas diarias"
	(fase buscar FALSE ?comida&:(not (or (eq Comida ?comida) (eq Cena ?comida))) ?dia)
	?posibles <- (alimentos-posibles (ids $?ids))
	(necesidades-cal (comida ?comida) (cal ?cal-restantes))
	(necesidades-macro (dia ?dia) (hidratos ?cal-hidratos)
								  (proteinas ?cal-proteinas)
								  (grasas ?cal-grasas))
	(menu (dia ?dia) (comida ?comida) (alimentos $?ids-alimentos))
	(alimento
		(id ?id&:(not (member$ ?id ?ids))&:(not (member$ ?id ?ids-alimentos))) ; seleccionar alimentos que no estén ya ni en la lista de posibles ni en la de incluidos en el menu
		(grupo ?grupo)
		(racion-minima ?racion)
		(kcal ?kcal&:(<= (* ?racion ?kcal 0.01) ?cal-restantes)) ; cal aportadas menor que cal restantes (g. racion * kcal/100g)
		(proteinas ?proteinas&:(<= (* ?racion ?proteinas 4 0.01) ?cal-proteinas)) ; cal aportadas por proteinas (g. racion * g. proteinas/100g * 4kcal/g)
		(hidratos ?hidratos&:(<= (* ?racion ?hidratos 4 0.01) ?cal-hidratos))
		(grasas ?grasas&:(<= (* ?racion ?grasas 9 0.01) ?cal-grasas))
		(indicado-para $? ?comida $?)
	)
	(raciones-por-grupo (grupo ?grupo) (raciones ?raciones&:(> ?raciones 0)))
	=>
	;(printout t "Encontrado alimento de " ?comida " para " ?dia ": " ?id crlf)
	(modify ?posibles (ids (insert$ ?ids 1 ?id))))

(defrule buscar-alimentos-comida-cena "Disparar las reglas que buscan postre, guarnición y principal para la comida o la cena"
	?fase <- (fase buscar FALSE ?comida&:(or (eq Comida ?comida) (eq Cena ?comida)) ?dia)
	=>
	(retract ?fase)
	(assert (fase buscar postre ?comida ?dia)))

; Busca todos los alimentos de postre y los añade a la lista de alimentos posibles
; Dispara regla "elegir-alimento"
(defrule buscar-alimentos-postre "Buscar postre para comida o cena"
	(fase buscar postre ?comida ?dia)
	?posibles <- (alimentos-posibles (ids $?ids))
	(necesidades-cal (comida ?comida) (cal ?cal-restantes))
	(necesidades-macro (dia ?dia) (hidratos ?cal-hidratos)
								  (proteinas ?cal-proteinas)
								  (grasas ?cal-grasas))
	(menu (dia ?dia) (comida ?comida) (alimentos $?ids-alimentos))
	(alimento
		(id ?id&:(not (member$ ?id ?ids))&:(not (member$ ?id ?ids-alimentos))) ; seleccionar alimentos que no estén ya ni en la lista de posibles ni en la de incluidos en el menu
		(grupo ?grupo)
		(racion-minima ?racion)
		(kcal ?kcal&:(<= (* ?racion ?kcal 0.01) ?cal-restantes)) ; cal aportadas menor que cal restantes (g. racion * kcal/100g)
		(proteinas ?proteinas&:(<= (* ?racion ?proteinas 4 0.01) ?cal-proteinas)) ; cal aportadas por proteinas (g. racion * g. proteinas/100g * 4kcal/g)
		(hidratos ?hidratos&:(<= (* ?racion ?hidratos 4 0.01) ?cal-hidratos))
		(grasas ?grasas&:(<= (* ?racion ?grasas 9 0.01) ?cal-grasas))
		(indicado-para $? Postre $?)
	)
	(raciones-por-grupo (grupo ?grupo) (raciones ?raciones&:(> ?raciones 0)))
	=>
	;(printout t "Encontrado postre para " ?comida " del " ?dia ": " ?id crlf)
	(modify ?posibles (ids (insert$ ?ids 1 ?id))))

; Busca todos los alimentos de guarnición y los añade a la lista de alimentos posibles
; Dispara regla "elegir-alimento"
(defrule buscar-alimentos-guarnicion "Buscar guarnición para comida o cena"
	(fase buscar guarnicion ?comida ?dia)
	?posibles <- (alimentos-posibles (ids $?ids))
	(necesidades-cal (comida ?comida) (cal ?cal-restantes))
	(necesidades-macro (dia ?dia) (hidratos ?cal-hidratos)
							      (proteinas ?cal-proteinas)
								  (grasas ?cal-grasas))
	(menu (dia ?dia) (comida ?comida) (alimentos $?ids-alimentos))
	(alimento
		(id ?id&:(not (member$ ?id ?ids))&:(not (member$ ?id ?ids-alimentos))) ; seleccionar alimentos que no estén ya ni en la lista de posibles ni en la de incluidos en el menu
		(grupo ?grupo)
		(racion-minima ?racion)
		(kcal ?kcal&:(<= (* ?racion ?kcal 0.01) ?cal-restantes)) ; cal aportadas menor que cal restantes (g. racion * kcal/100g)
		(proteinas ?proteinas&:(<= (* ?racion ?proteinas 4 0.01) ?cal-proteinas)) ; cal aportadas por proteinas (g. racion * g. proteinas/100g * 4kcal/g)
		(hidratos ?hidratos&:(<= (* ?racion ?hidratos 4 0.01) ?cal-hidratos))
		(grasas ?grasas&:(<= (* ?racion ?grasas 9 0.01) ?cal-grasas))
		(indicado-para $? ?comida $?)
		(acom TRUE)
	)
	(raciones-por-grupo (grupo ?grupo) (raciones ?raciones&:(> ?raciones 0)))
	=>
	;(printout t "Encontrado guarnición para " ?comida " del " ?dia ": " ?id crlf)
	(modify ?posibles (ids (insert$ ?ids 1 ?id))))

; Busca todos los alimentos de plato principal y los añade a la lista de alimentos posibles
; Dispara regla "elegir-alimento"
(defrule buscar-alimentos-principal "Buscar plato principal para comida o cena"
	(fase buscar principal ?comida ?dia)
	?posibles <- (alimentos-posibles (ids $?ids))
	(necesidades-cal (comida ?comida) (cal ?cal-restantes))
	(necesidades-macro (dia ?dia) (hidratos ?cal-hidratos)
						          (proteinas ?cal-proteinas)
								  (grasas ?cal-grasas))
	(menu (dia ?dia) (comida ?comida) (alimentos $?ids-alimentos))
	(alimento
		(id ?id&:(not (member$ ?id ?ids))&:(not (member$ ?id ?ids-alimentos))) ; seleccionar alimentos que no estén ya ni en la lista de posibles ni en la de incluidos en el menu
		(grupo ?grupo)
		(racion-minima ?racion)
		(kcal ?kcal&:(<= (* ?racion ?kcal 0.01) ?cal-restantes)) ; cal aportadas menor que cal restantes (g. racion * kcal/100g)
		(proteinas ?proteinas&:(<= (* ?racion ?proteinas 4 0.01) ?cal-proteinas)) ; cal aportadas por proteinas (g. racion * g. proteinas/100g * 4kcal/g)
		(hidratos ?hidratos&:(<= (* ?racion ?hidratos 4 0.01) ?cal-hidratos))
		(grasas ?grasas&:(<= (* ?racion ?grasas 9 0.01) ?cal-grasas))
		(indicado-para $? ?comida $?)
		(acom FALSE)
	)
	(raciones-por-grupo (grupo ?grupo) (raciones ?raciones&:(> ?raciones 0)))
	=>
	;(printout t "Encontrado principal para " ?comida " del " ?dia ": " ?id crlf)
	(modify ?posibles (ids (insert$ ?ids 1 ?id))))

; Si ningún alimento de los disponibles cumple con las restricciones calóricas
; existentes, finaliza la búsqueda y se pasa a buscar un alimento para la si-
; guiente comida del día o para el siguiente plato de la comida/cena.
; Dispara reglas "siguiente-plato-* o siguiente-comida"
(defrule comida-completada "No se han encontrado alimentos que se puedan añadir"
	(declare (salience -10))
	?fase <- (fase buscar ?plato ?comida ?dia)
	(alimentos-posibles (ids $?ids-posibles))
	(test (eq (length$ ?ids-posibles) 0))
	=>
	;(printout t "No se pueden añadir más alimentos a " ?comida " del " ?dia crlf)
	(retract ?fase)
	(assert (completo ?comida ?plato))
	(assert (fase siguiente comida ?comida ?plato ?dia)))

; Elegir aleatoriamente uno de los alimentos de entre la lista de alimentos posibles.
; Una vez elegido, hay que calcular el tamaño de la ración necesaria.
; Se diferencia del anterior en que 
; Dispara regla "informacion-alimento" antes de añadirlo al menú.
(defrule elegir-alimento
	(declare (salience -10))
	?fase <- (fase buscar ?plato ?comida ?dia)
	?posibles <- (alimentos-posibles (ids $?ids-posibles))
	(test (> (length$ ?ids-posibles) 0))
	=>
	;(printout t "Eligiendo aleatoriamente alimento para " ?plato " de " ?comida " del " ?dia crlf)
	(retract ?fase)
	; elegir aleatoriamente uno de los alimentos posibles
	(seed (round (* (time) 10000))) ; Si lo dejamos "de casa" random repite valores
	(bind ?total-alimentos (length$ ?ids-posibles))
	(bind ?posicion (random 1 ?total-alimentos))
	(bind ?id-alimento (nth$ ?posicion ?ids-posibles))
	(assert (fase info-alimento ?id-alimento ?comida ?dia ?plato))
	; resetear lista alimentos posibles
	(retract ?posibles)
	(assert (alimentos-posibles (ids))))

; Antes de añadir el alimento seleccionado al menú, debemos recuperar su información
; nutricional para calcular la ración. Se hace aquí para no sobrecargar las reglas
; anteriores y que de ese modo sean más fáciles de leer.
; Dispara regla "anyadir-racion" o "recalcular-racion"
(defrule informacion-alimento "Recuperar información nutricional sobre el alimento seleccionado"
	?f <- (fase info-alimento ?id-alimento ?comida ?dia ?plato)
	(alimento
		(id ?id-alimento)
		(racion-maxima ?racion)
		(kcal ?kcal)
		(proteinas ?proteinas)
		(hidratos ?hidratos)
		(grasas ?grasas))
	=>
	;(printout t "Recuperando información del alimento " ?id-alimento crlf)
	(retract ?f)
	; Probamos en primer lugar a añadir la ración máxima
	(assert (fase anyadir-racion ?id-alimento ?racion ?comida ?dia ?plato ?kcal ?proteinas ?hidratos ?grasas)))

; Se añade el alimento y su ración indicada al menú. Hay que comprobar que
; dicha ración cumple con las restricciones calóricas existentes, si no lo
; hace, entrará en juego la regla "recalcular-racion" en lugar de esta.
; Dispara regla "actualizar-cal"
(defrule anyadir-racion "Añadir la ración indicada del alimento al menú"
	(necesidades-cal (comida ?comida) (cal ?cal-restantes))
	(necesidades-macro (dia ?dia) (hidratos ?cal-hidratos)
							      (proteinas ?cal-proteinas)
								  (grasas ?cal-grasas))
	?f <- (fase anyadir-racion ?id-alimento ?racion ?comida ?dia ?plato
								?kcal&:(<= (* ?racion ?kcal 0.01) ?cal-restantes)
								?proteinas&:(<= (* ?racion ?proteinas 4 0.01) ?cal-proteinas)
								?hidratos&:(<= (* ?racion ?hidratos 4 0.01) ?cal-hidratos)
								?grasas&:(<= (* ?racion ?grasas 9 0.01) ?cal-grasas))
	?menu <- (menu (dia ?dia) (comida ?comida) (alimentos $?ids-alimentos))
	=>
	;(printout t "Añadiendo alimento " ?id-alimento " para " ?comida " del " ?dia crlf)
	(retract ?f)
	(modify ?menu (alimentos (insert$ ?ids-alimentos 1 ?id-alimento)))
	(assert (alimento-para ?dia ?comida ?id-alimento ?racion (* ?racion ?kcal 0.01)))
	(assert (fase actualizar-cal ?dia ?comida ?plato ?id-alimento ?racion))
)

; Sabemos, porque ya se ha comprobado en las reglas "buscar-alimentos", que
; el alimento en su ración mínima cumple con los requisitos calóricos necesarios.
; Si su ración máxima excede estos requisitos, hay que disminuirla progresiva-
; mente hasta que los cumpla.
; Re-dispara la regla "anyadir-racion" y a sí misma.
(defrule recalcular-racion "Restar peso de la ración del alimento indicado"
	(necesidades-cal (comida ?comida) (cal ?cal-restantes))
	(necesidades-macro (dia ?dia) (hidratos ?cal-hidratos)
							      (proteinas ?cal-proteinas)
							      (grasas ?cal-grasas))
	?f <- (fase anyadir-racion ?id-alimento ?racion ?comida ?dia ?plato ?kcal ?proteinas ?hidratos ?grasas)
	(test (or (> (* ?racion ?kcal 0.01) ?cal-restantes)
			   (> (* ?racion ?proteinas 4 0.01) ?cal-proteinas)
			   (> (* ?racion ?hidratos 4 0.01) ?cal-hidratos)
			   (> (* ?racion ?grasas 9 0.01) ?cal-grasas)
	))
	=>
	;(printout t "Recalculando ración para el alimento " ?id-alimento crlf)
	(retract ?f)
	(assert (fase anyadir-racion ?id-alimento (- ?racion 1) ?comida ?dia ?plato ?kcal ?proteinas ?hidratos ?grasas))
)

; Actualiza los hechos con la información de las calorías aportadas
; tras añadir el alimento.
; Dispara la regla "actualizar-grupos"
(defrule actualizar-cal "Actualizar los hechos que contienen las calorías aportadas hasta el momento"
	?f <- (fase actualizar-cal ?dia ?comida ?plato ?id-alimento ?racion)
	(alimento (id ?id-alimento) (kcal ?cal) (proteinas ?proteinas) (hidratos ?hidratos) (grasas ?grasas))
	?cal-comida <- (necesidades-cal (comida ?comida) (cal ?cal-restantes))
	?cal-macro <- (necesidades-macro (dia ?dia) (hidratos ?cal-restantes-hidratos)
												(proteinas ?cal-restantes-proteinas)
												(grasas ?cal-restantes-grasas))
	?registro-calorico <- (registro-calorico (dia ?dia) (cal ?reg-cal))
	?registro-macro <- (registro-macro (hidratos ?reg-hidratos) (proteinas ?reg-proteinas) (grasas ?reg-grasas))
	=>
	;(printout t "Actualizando calorías restantes tras añadir el alimento " ?id-alimento " a " ?comida " del " ?dia crlf crlf)
	(retract ?f)
	(bind ?cal-aportadas (* ?racion ?cal 0.01))
	(bind ?cal-hidratos-aportadas (* ?racion ?hidratos 0.01 4))
	(bind ?cal-proteinas-aportadas (* ?racion ?proteinas 0.01 4))
	(bind ?cal-grasas-aportadas (* ?racion ?grasas 0.01 9))
	(modify ?cal-comida (cal (- ?cal-restantes ?cal-aportadas)))
	(modify ?cal-macro (dia ?dia) (hidratos (- ?cal-restantes-hidratos ?cal-hidratos-aportadas))
							      (proteinas (- ?cal-restantes-proteinas ?cal-proteinas-aportadas))
								  (grasas (- ?cal-restantes-grasas ?cal-grasas-aportadas)))
	(modify ?registro-calorico (cal (+ ?reg-cal ?cal-aportadas)))
	(modify ?registro-macro (hidratos (+ ?reg-hidratos ?cal-hidratos-aportadas))
							(proteinas (+ ?reg-proteinas ?cal-proteinas-aportadas))
							(grasas (+ ?reg-grasas ?cal-grasas-aportadas)))
	(assert (fase actualizar-grupos ?id-alimento ?comida ?plato ?dia))
)

; Actualiza los hechos que contienen la información sobre cuántos
; alimentos de cada grupo se han incluido en el menú.
; El grupo del alimento no es ni el 3 ni el 6.
; Dispara reglas "siguiente-comida-*" y "siguiente-plato-*"
(defrule actualizar-grupos "Actualizar cantidad de alimentos de cada grupo"
	?f <- (fase actualizar-grupos ?id-alimento ?comida ?plato ?dia)
	(alimento (id ?id-alimento) (grupo ?grupo&:(not (or (eq ?grupo 3) (eq ?grupo 6)))))
	?raciones-grupo <- (raciones-por-grupo (grupo ?grupo) (raciones ?raciones))
	=>
	(retract ?f)
	(modify ?raciones-grupo (grupo ?grupo) (raciones (- ?raciones 1)))
	(assert (fase siguiente comida ?comida ?plato ?dia))
)

; Actualiza los hechos que contienen la información sobre cuántos
; alimentos de cada grupo se han incluido en el menú.
; Como los alimentos de los grupos 3 y 6 se cuentan combinados,
; se actualizan aquí simultáneamente ambos hechos cada vez que se
; añade al menú un alimento del grupo 3 o del grupo 6.
; Dispara reglas "siguiente-comida-*" y "siguiente-plato-*"
(defrule actualizar-grupos-2 "Actualizar cantidad de alimentos de los grupos 3 y 6"
	?f <- (fase actualizar-grupos ?id-alimento ?comida ?plato ?dia)
	(alimento (id ?id-alimento) (grupo ?grupo&:(or (eq ?grupo 3) (eq ?grupo 6))))
	?raciones-grupo-3 <- (raciones-por-grupo (grupo 3) (raciones ?raciones-3))
	?raciones-grupo-6 <- (raciones-por-grupo (grupo 6) (raciones ?raciones-6))
	=>
	(retract ?f)
	(modify ?raciones-grupo-3 (raciones (- ?raciones-3 1)))
	(modify ?raciones-grupo-6 (raciones (- ?raciones-6 1)))
	(assert (fase siguiente comida ?comida ?plato ?dia))
)

; Busca cuál es la siguiente comida del día utilizando la lista
; contenida en el hecho (comidas $?).
; Dispara la regla "buscar-alimentos"
(defrule siguiente-comida "Pasar a buscar alimentos para la siguiente comida del día"
	(comidas $?comidas)
	; Si la comida actual es la cena, lo tratamos en la regla "siguiente-comida-cena"
	?fase <- (fase siguiente comida ?comida&:(< (member$ ?comida ?comidas) 5) FALSE ?dia)
	=>
	(retract ?fase)
	(bind ?pos (member$ ?comida ?comidas))
	(bind ?siguiente-comida (nth$ (+ 1 ?pos) ?comidas))
	(assert (fase buscar FALSE ?siguiente-comida ?dia)))

; Dispara la regla "buscar-alimentos"
(defrule siguiente-comida-cena "Cambio de buscar alimentos para cena a buscar alimentos para desayuno"
	?fase <- (fase siguiente comida Cena FALSE ?dia)
	=>
	(retract ?fase)
	(assert (fase buscar FALSE Desayuno ?dia)))

; Tras buscar el alimento para el postre de la comida o la cena,
; hay que pasar a buscar el plato para la guarnición.
; Dispara la regla "buscar-alimentos-guarnicion"
(defrule siguiente-plato-a-postre "Cambio de buscar postre a buscar guarnición"
	?fase <- (fase siguiente comida ?comida postre ?dia)
	=>
	(retract ?fase)
	(assert (fase buscar guarnicion ?comida ?dia)))

; Tras buscar el alimento para la guarnnición de la comida o la cena,
; hay que pasar a buscar el alimento para el plato principal
; Dispara la regla "buscar-alimentos-principal"
(defrule siguiente-plato-a-guarnicion "Cambio de buscar guarnición a buscar plato principal"
	?fase <- (fase siguiente comida ?comida guarnicion ?dia)
	=>
	(retract ?fase)
	(assert (fase buscar principal ?comida ?dia)))

; Tras buscar el alimento para el plato principal de la comida o la
; cena, hay que pasar a buscar un alimento para la siguiente comida
; del día, que será o la merienda o el desayuno.
; Dispara la regla "siguiente-comida" o "siguiente-comida-cena"
(defrule siguiente-plato-a-principal "Cambio de buscar plato principal a buscar alimento siguiente comida"
	?fase <- (fase siguiente comida ?comida principal ?dia)
	=>
	(retract ?fase)
	(assert (fase siguiente comida ?comida FALSE ?dia)))

; No se pueden añadir más alimentos al menú del día actual, por
; lo que se debe pasar a buscar alimentos para el menú del siguiente
; día de la semana.
; Se resetean las raciones aportadas para cada grupo de alimentos
; y las calorías aportadas para empezar de cero en el siguiente día.
; Dispara la regla "buscar-alimentos"
(defrule siguiente-dia "Comenzar elaboración del menú para el siguiente día de la semana"
	(dias $?dias)
	(gasto-energetico ?gasto)
	?fase <- (fase buscar ? ?comida ?dia&:(not (eq ?dia viernes)))
	?f1 <- (completo Desayuno FALSE)
	?f2 <- (completo Almuerzo FALSE)
	?f3 <- (completo Comida principal)
	?f4 <- (completo Comida guarnicion)
	?f5 <- (completo Comida postre)
	?f6 <- (completo Merienda FALSE)
	?f7 <- (completo Cena principal)
	?f8 <- (completo Cena guarnicion)
	?f9 <- (completo Cena postre)
	?r1 <- (raciones-por-grupo (grupo 1))
	?r2 <- (raciones-por-grupo (grupo 2))
	?r3 <- (raciones-por-grupo (grupo 3))
	?r4 <- (raciones-por-grupo (grupo 4))
	?r5 <- (raciones-por-grupo (grupo 5))
	?r6 <- (raciones-por-grupo (grupo 6))
	?n1 <- (necesidades-cal (comida Desayuno))
	?n2 <- (necesidades-cal (comida Almuerzo))
	?n3 <- (necesidades-cal (comida Comida))
	?n4 <- (necesidades-cal (comida Merienda))
	?n5 <- (necesidades-cal (comida Cena))
	=>
	(modify ?r1 (grupo 1) (raciones 3))
	(modify ?r2 (grupo 2) (raciones 3))
	(modify ?r3 (grupo 3) (raciones 6))
	(modify ?r4 (grupo 4) (raciones 4))
	(modify ?r5 (grupo 5) (raciones 3))
	(modify ?r6 (grupo 6) (raciones 6))
	(modify ?n1 (cal (* ?gasto 0.2)))
	(modify ?n2 (cal (* ?gasto 0.15)))
	(modify ?n3 (cal (* ?gasto 0.3)))
	(modify ?n4 (cal (* ?gasto 0.15)))
	(modify ?n5 (cal (* ?gasto 0.2)))
	(retract ?fase ?f1 ?f2 ?f3 ?f4 ?f5 ?f6 ?f7 ?f8 ?f9)
	(bind ?pos (member$ ?dia ?dias))
	(bind ?siguiente-dia (nth$ (+ 1 ?pos) ?dias))
	(assert (fase buscar FALSE Desayuno ?siguiente-dia))
)

; Al no poder añadir más alimentos para el menú del viernes,
; la elaboración de la dieta ha finalizado. Sólo queda imprimir
; los resultados.
; Dispara la regla "imprimir-dia"
(defrule siguiente-dia-viernes "Menú completo, pasamos a imprimir"
	(dias $?dias)
	?fase <- (fase buscar ? ?comida viernes)
	?f1 <- (completo Desayuno FALSE)
	?f2 <- (completo Almuerzo FALSE)
	?f3 <- (completo Comida principal)
	?f4 <- (completo Comida guarnicion)
	?f5 <- (completo Comida postre)
	?f6 <- (completo Merienda FALSE)
	?f7 <- (completo Cena principal)
	?f8 <- (completo Cena guarnicion)
	?f9 <- (completo Cena postre)
	(nombre-usuario ?nombre)
	(gasto-energetico ?gasto)
	=>
	(retract ?fase ?f1 ?f2 ?f3 ?f4 ?f5 ?f6 ?f7 ?f8 ?f9)
	(printout t crlf ?nombre ", hemos calculado que necesitas " ?gasto " kcal diarias." crlf "Este es el menú semanal que te hemos preparado:" crlf crlf)
	(printout t "@-------------------------------------------------------@" crlf)
	(assert (fase imprimir lunes)))


;;;**************************
;;;* 4. Imprimir resultados *
;;;**************************

; Dispara la regla "imprimir-nombre-comida"
(defrule imprimir-dia "Muestra el día de la semana"
	?fase <- (fase imprimir ?dia)
	=>
	(printout t "|                                                       |" crlf)
	(format t "| %-54s|%n" (upcase ?dia))
	(printout t "|                                                       |" crlf)
	(retract ?fase)
	(assert (fase imprimir nombre ?dia Desayuno)))

; Dispara la regla "imprimir-alimentos-menu" o "imprimir-siguiente-comida"
(defrule imprimir-nombre-comida "Muestra la comida del día (Desayuno, Almuerzo, Comida...)"
	?fase <- (fase imprimir nombre ?dia ?comida)
	=>
	(format t "| %-54s|%n" (str-cat ?comida ":"))
	(retract ?fase)
	(assert (fase imprimir menu ?dia ?comida)))


(defrule imprimir-alimentos-menu "Imprimie los alimentos para la comida de un día"
	(fase imprimir menu ?dia ?comida)
	(alimento-para ?dia ?comida ?id ?racion ?cal)
	(alimento (id ?id) (nombre ?nombre))
	=>
	(format t "|           %-20s %5d gr. %5d kcal   |%n" ?nombre ?racion ?cal))

; Si no estamos imprimiendo los alimentos para la cena (en este caso tenemos
; que cambiar también de día), esta regla hace que se pase a imprimir los
; alimentos de la siguiente comida del día.
; Dispara la regla "imprimir-nombre-comida"
(defrule imprimir-siguiente-comida "Pasar a la siguiente comida del día (Desayuno a Merienda, Merienda a Comida, etc.)"
	(declare (salience -10))
	(comidas $?comidas)
	?fase <- (fase imprimir menu ?dia ?comida&:(< (member$ ?comida ?comidas) 5))
	=>
	(retract ?fase)
	(bind ?pos (member$ ?comida ?comidas))
	(bind ?siguiente-comida (nth$ (+ 1 ?pos) ?comidas))
	(assert (fase imprimir nombre ?dia ?siguiente-comida)))

; Tras imprimir la cena (última comida del día), mostramos un resumen
; con las calorías aportadas por el menú y pasamos a buscar los
; alimentos para el siguiente día de la semana.
; Dispara la regla "imprimir-dia"
(defrule imprimir-info-diaria "Imprimir resumen calórico diario y pasar al siguiente día"
	(declare (salience -10))
	(dias $?dias)
	?fase <- (fase imprimir menu ?dia ?comida&:(eq ?comida Cena))
	(registro-calorico (dia ?dia) (cal ?cal-aportadas))
	(gasto-energetico ?gasto-diario)
	(necesidades-macro (dia ?dia) (hidratos ?hidratos-restantes)
								  (proteinas ?proteinas-restantes)
								  (grasas ?grasas-restantes))
	=>
	(retract ?fase)
	(bind ?hidratos-necesarios (* ?gasto-diario 0.50))
	(bind ?proteinas-necesarios (* ?gasto-diario 0.15))
	(bind ?grasas-necesarios (* ?gasto-diario 0.35))
	(bind ?porcentaje-hidratos (* 100 (/ (- ?hidratos-necesarios ?hidratos-restantes) ?gasto-diario)))
	(bind ?porcentaje-proteinas (* 100 (/ (- ?proteinas-necesarios ?proteinas-restantes) ?gasto-diario)))
	(bind ?porcentaje-grasas (* 100 (/ (- ?grasas-necesarios ?grasas-restantes) ?gasto-diario)))
	(printout t "|                                                       |" crlf)
	(format t "| TOTAL     %% proteinas:       %5.1f                    |%n" ?porcentaje-proteinas)
	(format t "|           %% hidratos:        %5.1f                    |%n" ?porcentaje-hidratos)
	(format t "|           %% grasas:          %5.1f                    |%n" ?porcentaje-grasas)
	(format t "|           Calorías:          %5d                    |%n" ?cal-aportadas)
	(format t "|           Déficit calórico:  %5d                    |%n" (- ?gasto-diario ?cal-aportadas))
	(printout t "|-------------------------------------------------------|" crlf)
	(bind ?pos (member$ ?dia ?dias))
	(bind ?siguiente-dia (nth$ (+ 1 ?pos) ?dias)) ; Nótese que esta operación, si ?pos es 5 (viernes), asignará nil (vacío) a
												  ; ?siguiente-dia, con lo que se disparará la regla "imprimir-info-semanal"
	(assert (fase imprimir ?siguiente-dia)))

; Última regla del Sistema Experto. Recuperamos la información calórica diaria y semanal
; e imprimimos el informe final.
(defrule imprimir-info-semanal "Imprimir resumen calórico semanal y finalizar ejecución"
	(declare (salience 10))
	?fase <- (fase imprimir nil) ; un poco chapuza pero ya que es la última regla que se dispara... Y así se evita añadir una regla específica para la info del viernes
	(registro-calorico (dia lunes) (cal ?cal-lunes))
	(registro-calorico (dia martes) (cal ?cal-martes))
	(registro-calorico (dia miercoles) (cal ?cal-miercoles))
	(registro-calorico (dia jueves) (cal ?cal-jueves))
	(registro-calorico (dia viernes) (cal ?cal-viernes))
	(registro-macro (hidratos ?hidratos-aportados)
				    (proteinas ?proteinas-aportadas)
					(grasas ?grasas-aportadas))
	(gasto-energetico ?gasto-diario)
	=>
	(retract ?fase)
	(bind ?porcentaje-hidratos (* 20 (/ ?hidratos-aportados ?gasto-diario)))
	(bind ?porcentaje-proteinas (* 20 (/ ?proteinas-aportadas ?gasto-diario)))
	(bind ?porcentaje-grasas (* 20 (/ ?grasas-aportadas ?gasto-diario)))
	(bind ?cal-aportadas (+ ?cal-lunes ?cal-martes ?cal-miercoles ?cal-jueves ?cal-viernes))
	(printout t "|                                                       |" crlf)
	(format t "| TOTAL     %% proteinas:       %5.1f                    |%n" ?porcentaje-proteinas)
	(format t "| SEMANA    %% hidratos:        %5.1f                    |%n" ?porcentaje-hidratos)
	(format t "|           %% grasas:          %5.1f                    |%n" ?porcentaje-grasas)
	(format t "|           Calorías:          %5d                    |%n" ?cal-aportadas)
	(format t "|           Déficit calórico:  %5d                    |%n" (- (* 5 ?gasto-diario) ?cal-aportadas))
	(printout t "|                                                       |" crlf)
	(printout t "@-------------------------------------------------------@" crlf)
	(printout t crlf "(-:" crlf))
