state("AER") {
    bool isLoading : 0x1036588, 0x4, 0x4C, 0x18, 0x0, 0xC, 0x14;
}

init {
	refreshRate = 1000/2; // two times a second or every 500ms
	if(game != null) {
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
