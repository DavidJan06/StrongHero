extends TileMap

var noise = FastNoiseLite.new()  # Reuse the noise object or create a new one
var size_x = 100
var size_y = 100

var Sand:Dictionary
var GrassElevation:Dictionary
var Grass:Dictionary
var MountainElevation:Dictionary
var Mountains:Dictionary

func _ready():
	noise.set_offset(Vector3(randf_range(-100.0,100.0), randf_range(-100.0,100.0), randf_range(-100.0,100.0)))
	
	for x in range(size_x):
		for y in range(size_y):
			#for z in range(size_z):
			var tile
			var height = abs(round(noise.get_noise_2d(x, y)*10))
			#print(height)
			if height > 1:
				tile = {"layer":2,"source_id":0,"atlas_coords":Vector2i(6,1),"type":"sand"}
				
				Sand[Vector2i(x,y)] = tile
			
			if height > 2:
				tile = {"layer":4,"source_id":0,"atlas_coords":Vector2i(1,1),"type":"grass"}
				Grass[Vector2i(x,y)] = tile
				
			if height > 4:
				tile = {"layer":6,"source_id":1,"atlas_coords":Vector2i(1,1),"type":"mountain"}
				Mountains[Vector2i(x,y)] = tile

	# Round Corners of Land
	RoundCorners(Sand)
	RoundCorners(Grass)
	RoundCorners(Mountains)
	AddElevation(Grass,GrassElevation, 3)
	AddElevation(Mountains, MountainElevation, 5)
	
	# Make World
	for x in range(size_x):
		for y in range(size_y):
			if !Sand.has(Vector2i(x,y)):
				set_cell(0,Vector2i(x,y),4,Vector2i(0,0))
			else:
				set_cell(1,Vector2i(x,y),5,Vector2i(0,0))
			
			if Sand.has(Vector2i(x,y)):
				set_cell(Sand[Vector2i(x,y)].layer,Vector2i(x,y),Sand[Vector2i(x,y)].source_id,Sand[Vector2i(x,y)].atlas_coords)
			
			if GrassElevation.has(Vector2i(x,y)):
				set_cell(GrassElevation[Vector2i(x,y)].layer,Vector2i(x,y),GrassElevation[Vector2i(x,y)].source_id,GrassElevation[Vector2i(x,y)].atlas_coords)
			
			if Grass.has(Vector2i(x,y)):
				set_cell(Grass[Vector2i(x,y)].layer,Vector2i(x,y),Grass[Vector2i(x,y)].source_id,Grass[Vector2i(x,y)].atlas_coords)
			
			if MountainElevation.has(Vector2i(x,y)):
				set_cell(MountainElevation[Vector2i(x,y)].layer,Vector2i(x,y),MountainElevation[Vector2i(x,y)].source_id,MountainElevation[Vector2i(x,y)].atlas_coords)
			
			if Mountains.has(Vector2i(x,y)):
				set_cell(Mountains[Vector2i(x,y)].layer,Vector2i(x,y),Mountains[Vector2i(x,y)].source_id,Mountains[Vector2i(x,y)].atlas_coords)

func RoundCorners(Tiles):
	for x in range(size_x):
		for y in range(size_y):
			if !Tiles.has(Vector2i(x,y)):
				continue
			
			var coord = Vector2i(x,y)
			var setter = [1,1,1,1]
			# x-1, x+1 , y-1, y+1
			
			if Tiles.has(Vector2i(x-1,y)):
				if Tiles[Vector2i(x-1,y)].type != Tiles[coord].type:
					setter[0] = 0
			else:
				setter[0] = 0
				
			if Tiles.has(Vector2i(x+1,y)):
				if Tiles[Vector2i(x+1,y)].type != Tiles[coord].type:
					setter[1] = 0
			else:
				setter[1] = 0
				
			if Tiles.has(Vector2i(x,y-1)):
				if Tiles[Vector2i(x,y-1)].type != Tiles[coord].type:
					setter[2] = 0
			else:
				setter[2] = 0
				
			if Tiles.has(Vector2i(x,y+1)):
				if Tiles[Vector2i(x,y+1)].type != Tiles[coord].type:
					setter[3] = 0
			else:
				setter[3] = 0
			
			match setter:
				[0,0,0,0]: # solo
					if Tiles[coord].type == "mountain":
						Tiles[coord].atlas_coords += Vector2i(2,3)
					else:
						Tiles[coord].atlas_coords += Vector2i(2,2)
				[0,1,0,1]: # Top left
					Tiles[coord].atlas_coords += Vector2i(-1,-1)
				[1,0,0,1]: # Top right
					Tiles[coord].atlas_coords += Vector2i(1,-1)
				[0,1,1,0]: # Bottom left
					Tiles[coord].atlas_coords += Vector2i(-1,1)
				[1,0,1,0]: # Bottom right
					Tiles[coord].atlas_coords += Vector2i(1,1)
				[0,1,1,1]: # left
					Tiles[coord].atlas_coords += Vector2i(-1,0)
				[1,0,1,1]: # right
					Tiles[coord].atlas_coords += Vector2i(1,0)
				[1,1,0,1]: # top
					Tiles[coord].atlas_coords += Vector2i(0,-1)
				[1,1,1,0]: # bottom
					Tiles[coord].atlas_coords += Vector2i(0,1)
				[0,1,0,0]: # left alone
					if Tiles[coord].type == "mountain":
						Tiles[coord].atlas_coords += Vector2i(-1,3)
					else:
						Tiles[coord].atlas_coords += Vector2i(-1,2)
				[1,0,0,0]: # right alone
					if Tiles[coord].type == "mountain":
						Tiles[coord].atlas_coords += Vector2i(1,3)
					else:
						Tiles[coord].atlas_coords += Vector2i(1,2)
				[0,0,0,1]: # top alone
					Tiles[coord].atlas_coords += Vector2i(2,-1)
				[0,0,1,0]: # bottom alone
					Tiles[coord].atlas_coords += Vector2i(2,1)
				[0,0,1,1]: # UP DOWN
					Tiles[coord].atlas_coords += Vector2i(2,0)
				[1,1,0,0]: # left right
					if Tiles[coord].type == "mountain":
						Tiles[coord].atlas_coords += Vector2i(0,3)
					else:
						Tiles[coord].atlas_coords += Vector2i(0,2)

func AddElevation(Tiles, ElevationTiles, Layer):
	for x in range(size_x):
		for y in range(size_y):
			if !Tiles.has(Vector2i(x,y)):
				continue
			
			var coord = Vector2i(x,y)
			var setter = [1,1,1,1]
			# x-1, x+1 , y-1, y+1
			
			if Tiles.has(Vector2i(x-1,y)):
				if Tiles[Vector2i(x-1,y)].type != Tiles[coord].type:
					setter[0] = 0
			else:
				setter[0] = 0
				
			if Tiles.has(Vector2i(x+1,y)):
				if Tiles[Vector2i(x+1,y)].type != Tiles[coord].type:
					setter[1] = 0
			else:
				setter[1] = 0
				
			if Tiles.has(Vector2i(x,y-1)):
				if Tiles[Vector2i(x,y-1)].type != Tiles[coord].type:
					setter[2] = 0
			else:
				setter[2] = 0
				
			if Tiles.has(Vector2i(x,y+1)):
				if Tiles[Vector2i(x,y+1)].type != Tiles[coord].type:
					setter[3] = 0
			else:
				setter[3] = 0
				
			var place_coord = coord + Vector2i(0,1)
			match setter:
				[0,1,1,0]: # Bottom left
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(0,2),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(0,3),"type":"elevation"}
				[1,0,1,0]: # Bottom right
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(2,2),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(2,3),"type":"elevation"}
				[1,1,1,0]: # bottom
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(1,2),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(1,3),"type":"elevation"}
				[0,1,1,1]: # left
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(0,1),"type":"elevation"}
				[1,0,1,1]: # right
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(2,1),"type":"elevation"}
				[0,1,0,0]: # left alone
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(0,4),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(0,5),"type":"elevation"}
				[1,0,0,0]: # right alone
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(2,4),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(2,5),"type":"elevation"}
				[0,0,1,0]: # bottom alone
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(3,2),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(3,3),"type":"elevation"}
				[0,0,0,0]: # solo
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(3,4),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(3,5),"type":"elevation"}
				[1,1,0,0]: # left right
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(1,4),"type":"elevation"}
					ElevationTiles[place_coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(1,5),"type":"elevation"}
				[0,1,0,1]: # Top left
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(0,0),"type":"elevation"}
				[1,0,0,1]: # Top right
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(2,0),"type":"elevation"}
				[1,1,0,1]: # top
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(1,0),"type":"elevation"}
				[0,0,0,1]: # top alone
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(3,0),"type":"elevation"}
				[0,0,1,1]: # UP DOWN
					ElevationTiles[coord] = {"layer":Layer,"source_id":6,"atlas_coords":Vector2i(3,1),"type":"elevation"}
