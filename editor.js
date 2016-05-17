// Function for the EntroPipe's Puzzle Editor
// Autor: Z80ST-Software
// z80st.software@gmail.com
// January 2013: First version
// Modify by Alfonso Saavedra "Son Link" and license under the GPL 3 license.

var W = 8; // Width
var H = 6; // Heigth

var aPlantilla = new Array(W*H); // Array con la plantilla del puzzle

// Draw the puzzle grid
function writePlantilla() {
	var casilla = 0;
	var table='';
	for ( y = 0 ; y < H ; y++ ) {
		table += "<tr>";
		for ( x = 0 ; x < W ; x++ ) {
			//table += '<td><img id="c'+(casilla++)+'" src="'+imArray[0].src+'" onClick="setCasilla(this);return true;" /></td>';
			table += '<td><div id="c'+(casilla++)+'" onClick="setCasilla(this);return true;" class="p0"/></td>';
		}
		table += "</tr>";
    }
	document.getElementById('plantilla').innerHTML = table;
}

// Init the puzzle grid
function initPlantilla() {
	for ( x = 0 ; x < W*H ; x++ ) {
		aPlantilla[x]=0;
    }
	calcEntropy();
}

// Convert the grid to string of hexadecimal values
function valoresPlantilla() {
	cadena = ''
	for ( x = 0 ; x < W*H ; x=x+2 ) {
		cadena = cadena + aPlantilla[x] + aPlantilla[x+1];
    }
  return ( cadena );
}
// Load a string of hexadecimal values to grid
function lPuzzle() {
	var aux = new Array(W*H);
	var cargados = 0;
	loading = document.getElementById("loadArea");
	for ( x = 0 ; (x < loading.value.length) && (cargados < W*H) ; x++ ) {
		c = loading.value.substr(x,1);
		if ( ( c >= "0" && c <= "9" ) || ( c >= "A" && c<="F" ) ) {
			aux[cargados] = c;
			cargados++;
        }
    }
	if ( cargados == W*H ) {
		aPlantilla = aux;
		calcEntropy();
		alert ( "load complete" );
    } else {
		alert ( "load failure "+cargados );
    }
	loading.value = "";
}

function mod(x,y) {
	while ( x >= y ) { x = x - y }
	while ( x < 0 ) { x = x + y }
	return ( x );
}

// Whole move grid to up
function shiftUp() {
	var aux = new Array(W);
	for ( x = 0 ; x < W ; x++ ) {
		aux[x]=aPlantilla[x];
    }
	for ( x = 0 ; x < W*(H-1) ; x++ ) {
		aPlantilla[x] = aPlantilla[mod(x+W,W*H)];
	}
	for ( x = 0 ; x < W ; x++ ) {
		aPlantilla[x+(W*(H-1))] = aux[x];
    }
	calcEntropy();
}

// Whole move grid to down
function shiftDown() {
	var aux = new Array(W);
	for ( x = 0 ; x < W ; x++ ) {
		aux[x]=aPlantilla[x+(W*(H-1))];
    }
	for ( x = W*H-1 ; x >= W ; x-- ) {
		aPlantilla[x] = aPlantilla[mod(x-W,W*H)];
    }
	for ( x = 0 ; x < W ; x++ ) {
		aPlantilla[x] = aux[x];
    }
	calcEntropy();
}

// Whole move grid to left
function shiftLeft() {
	var aux = new Array(H);
	for ( x = 0 ; x < H ; x++ ) {
		aux[x]=aPlantilla[x*W];
	}
	for ( x = 0 ; x < W*H ; x++ ){
		if ( mod(x,W) < W-1 ) {
			aPlantilla[x] = aPlantilla[x+1];
		}
	}
	for ( x = 0 ; x < H ; x++ ){
		aPlantilla[x*W+(W-1)] = aux[x];
	}
	calcEntropy();
}

// Whole move template to right
function shiftRight() {
	var aux = new Array(H);
	for ( x = 0 ; x < H ; x++ ) {
		aux[x]=aPlantilla[x*W+(W-1)];
    }
  for ( x = W*H-1 ; x > 0 ; x-- ) {
		if ( mod(x,W) > 0 ) {
			aPlantilla[x] = aPlantilla[x-1];
		}
    }
  for ( x = 0 ; x < H ; x++ ) {
		aPlantilla[x*W] = aux[x];
    }
	calcEntropy();
}

// Update one box
function setCasilla(casilla) {
	aPlantilla[casilla.id.substring(1,casilla.id.length)]=currentTile;
	casilla.className = '';
	casilla.classList.add('p'+currentTile);
	calcEntropy();
}

// Select a tile
function selectTile(tile) {
	document.querySelector("#t"+currentTile + ' > div').classList.remove('selected');
	actualTile = document.getElementById(tile.id)
	document.querySelector('#'+tile.id + ' > div').classList.add('selected');
	currentTile=tile.id.substring(1,tile.id.length);
}

// Function for check in the four directions
function checkUp(tile) { return ( "13579BDF".match(tile) ); }
function checkDown(tile) { return ( "4567CDEF".match(tile) ); }
function checkRight(tile) { return ( "2367ABEF".match(tile) ); }
function checkLeft(tile) { return ( "89ABCDEF".match(tile) ); }

// Update and redraw the grid
function calcEntropy() {
	// Calculate the puzzle entropy
	var entropy = 0;
	var entropyLocal;
	for ( y = 0 ; y < H ; y++ ) {
		for ( x = 0 ; x < W ; x++ ) {
			entropyLocal = 0;
			if  ( ( checkUp(aPlantilla[y*W+x]) ) && ( ( y == 0 ) || ( !checkDown(aPlantilla[(y-1)*W+x]) ) ) ) { entropyLocal++ }
			if  ( ( checkDown(aPlantilla[y*W+x]) ) && ( ( y == H-1 ) || ( !checkUp(aPlantilla[(y+1)*W+x]) ) ) ) { entropyLocal++ }
			if  ( ( checkRight(aPlantilla[y*W+x]) ) && ( ( x == W-1 ) || ( !checkLeft(aPlantilla[y*W+x+1]) ) ) ) { entropyLocal++ }
			if  ( ( checkLeft(aPlantilla[y*W+x]) ) && ( ( x == 0 ) || ( !checkRight(aPlantilla[y*W+x-1]) ) ) ) { entropyLocal++ }
			entropy += entropyLocal;
		}
	}

	// actualizamos la cadena con la entropía del puzzle
	var spn = document.getElementById("entropy");
	spn.innerHTML = "<b>Puzzle Entropy: " + entropy + "</b>";
	// actualizamos la cadena con el contenido del array	
	var spn = document.getElementById("final");
	spn.value = valoresPlantilla();
}

// Change the grid size and init all variables and redraw
function gridSize(){
	// change the game grid size
	v = document.getElementById('gridsize').value.split('x');
	W = parseInt(v[0]);
	H = parseInt(v[1]);
	aPlantilla = new Array(W*H);
	currentTile = 0;         // Indicamos que el tile seleccionado es el 0
	writePlantilla()
	initPlantilla();	// Inicializamos el array con la plantilla
	//tileSelector();		// Cambiamos el color del borde de todos los tiles seleccionables
	selectTile(document.getElementById('t0')); // Seleccionamos graficamente el tile 0
	setCasilla(document.getElementById('c0')); // inicializamos la cadena del puzzle
	document.getElementById("final").value = valoresPlantilla()
}

document.addEventListener('DOMContentLoaded', function(){
    gridSize()
}, false);
