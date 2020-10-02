<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>Recetas</title>
	<link rel="stylesheet" type="text/css" href="http://fonts.googleapis.com/css?family=Dosis">
	<link rel="stylesheet" href="<?php echo URL; ?>assets/css/font-awesome.min.css" />
	<link rel="stylesheet" href="<?php echo URL; ?>assets/fonts/awards/awards.css" />
	<link rel="stylesheet" href="<?php echo URL; ?>assets/css/styles.css" />
	<!--[if lt IE 9]>
	    <script src="assets/js/html5shiv.js"></script>
	<![endif]-->
</head>
<body>
	<section id="rw-layout" class="rw-layout">
	<!--Header-->
		<div class="rw-section rw-header">
			<div class="rw-inner clearfix">
				<div class="grid-container">

					<div class="grid desk-8 mob-6 alpha clearfix">
						<div class="logo-holder">
							<img src="<?php echo URL; ?>assets/placeholder/logo.png" class="logo" alt="" />
						</div>
						<nav id="the-main-menu" class="main-menu-nav menu-inline" data-breakpoint="1160">
							<ul class="menu horizontal">
								<li><a href="index.php">Inicio</a></li>
								<li>
									<a href="recipes.php">Recetas</a>
									<ul class="sub-menu">
										<li><a href="single-recipe.php">Listado completo</a></li>
										<li><a href="single-recipe.php">Listado por categoría</a></li>
										<li><a href="submit-recipe.php">Enviar receta</a></li>
									</ul>
								</li>			
								<li>
									<a href="recipe-tag-index.php">Buscar</a>
									<ul class="sub-menu">
										<li><a href="recipe-tag-index.php">Etiquetas</a></li>
										<li><a href="recipe-ingredients.php">Ingredientes</a></li>
									</ul>
								</li>
							</ul>
						</nav>
					</div>
				</div> <!-- .grid-container -->
			</div> <!-- .rw-inner -->
		</div> <!-- .rw-header -->
<!--Content-->