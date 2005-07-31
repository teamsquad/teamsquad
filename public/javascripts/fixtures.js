window.onload = startUp;

var games = 1;
var match = 1;
var hours;
var mins;
var teams;
var deler;
var adder;
var table;

function startUp()
{
	hours = document.getElementById('hour_1').cloneNode(true);
	mins  = document.getElementById('minute_1').cloneNode(true);
	teams = document.getElementById('hometeam_1').cloneNode(true);
	deler = document.getElementById('del_1').cloneNode(true);
	deler.disabled = false;
	adder = document.getElementById('add_1').cloneNode(true);
	table = document.getElementById('fixtures');
}

function addRow(obj)
{
	dadhour   = 'hour'+obj.parentNode.parentNode.id
	dadminute = 'minute'+obj.parentNode.parentNode.id

	match++;
	games++;
	tr    = document.createElement('TR');
	tr.id = ('_' + match);
	cell1 = document.createElement('TD');
	cell1.className = 'when';
	cell2 = document.createElement('TD');
	cell2.className = 'home team';
	cell3 = document.createElement('TD');
	cell3.className = 'versus';
	cell4 = document.createElement('TD');
	cell4.className = 'away team';
	cell5 = document.createElement('TD');
	cell6 = document.createElement('TD');
	// cell 1
	myhours      = hours.cloneNode(true);
	myhours.id   = ('hour_' + match);
	myhours.name = ('game[' + match + '][hour]');
	myhours.selectedIndex = document.getElementById(dadhour).selectedIndex;
	mymins       = mins.cloneNode(true);
	mymins.id    = ('minute_' + match);
	mymins.name  = ('game[' + match + '][minute]');
	mymins.selectedIndex = document.getElementById(dadminute).selectedIndex;
	cell1.appendChild(myhours);
	cell1.appendChild(document.createTextNode(':'));
	cell1.appendChild(mymins);
	// cell 2
	myhometeams      = teams.cloneNode(true);
	myhometeams.id   = ('hometeam_' + match);
	myhometeams.name = ('game[' + match + '][hometeam]');
	cell2.appendChild(myhometeams);
	// cell 3
	cell3.appendChild(document.createTextNode('v'));
	// cell 4
	myawayteams      = teams.cloneNode(true);
	myawayteams.id   = ('awayteam_' + match);
	myawayteams.name = ('game[' + match + '][awayteam]');
	cell4.appendChild(myawayteams);	
	// cell 5
	mydeler = deler.cloneNode(true);
	mydeler.id = ('del_' + match);
	cell5.appendChild(mydeler);
	// cell 6
	myadder = adder.cloneNode(true);
	myadder.id = ('add_' + match);
	cell6.appendChild(myadder);
	// put it all together
	tr.appendChild(cell1);
	tr.appendChild(cell2);
	tr.appendChild(cell3);
	tr.appendChild(cell4);
	tr.appendChild(cell5);
	tr.appendChild(cell6);
	obj.parentNode.parentNode.parentNode.insertBefore(tr,obj.parentNode.parentNode.nextSibling);
	for (i=1;i<match;i++)
	{
		inp = document.getElementById('del_'+i);
		if (inp)
		{
			inp.disabled=false;
			i=match;
		}
	}
}

function delRow(obj)
{
	if (games != 1)
	{
		obj.parentNode.parentNode.parentNode.removeChild(obj.parentNode.parentNode);
		games-=1;
		if (games == 1)
		{
			for (i=1;i<match;i++)
			{
				inp = document.getElementById('del_'+i);
				if (inp) { inp.disabled=true; i=match;}
			}
		}
	}
	else
	{
		alert('You can\'t remove a fixture from the list if it is the only one.')
	}
}