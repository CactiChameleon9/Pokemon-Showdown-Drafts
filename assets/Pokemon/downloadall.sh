for j in {2..6}
do

	for i in {0..9}
	do
		wget "https://assets.pokemon.com/assets/cms2/img/pokedex/full/00"$i"_f$j.png"
	done
	for i in {10..99}
	do
		wget "https://assets.pokemon.com/assets/cms2/img/pokedex/full/0"$i"_f$j.png"
	done
	for i in {100..910}
	do
		wget "https://assets.pokemon.com/assets/cms2/img/pokedex/full/"$i"_f$j.png"
	done

done
