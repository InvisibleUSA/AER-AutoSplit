state("AER") {
    bool isLoading : 0xFF84D0, 0x124, 0x1F8, 0x78, 0xB8, 0x56C;
}

init {
	refreshRate = 1000/2; // two times a second or every 500ms
	if(game.Handle != null) {
		if((int)game.Handle > 0) {
			// all good
		}
		else {
			throw new Exception("AER not yet connected to LiveSplit");
		}
	}
	else {
		throw new Exception("AER not yet connected to LiveSplit");
	}
	refreshRate = 60; // set the refreshRate back since the init completed
}

start {

}

update {
	if(current.isLoading != null) {
		if(old.isLoading != current.isLoading) {
			print(" «[AER-Splitter]» update{} - isLoading changed from " + old.isLoading + " to " + current.isLoading);
		}
	}
}

split {
	
}

reset {
	
}

isLoading {
	// check if isLoading has been initialized yet and return it's value if it is
	if(current.isLoading != null) {
		return current.isLoading;
	}
	else {
		return false;
	}
}