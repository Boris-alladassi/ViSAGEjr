### Set working directory if needed
# setwd("C:/Users/aboris/Box/Postdoc_UIUC/Omnigenic_Project/code/shiny_app2/app_row_column_design")

###### Simulation in AlphaSimR ####################################################
########### Maize #######################################################################
### Create, save, and preload a founder population for maize
# founder.pop <- runMacs(nInd = 100, nChr = 10, segSites = 10,
#                        species = "MAIZE", inbred = T)
# saveRDS(founder.pop, "R/Maize.founder.population.preloaded.rds")

### Adding two negatively correlated traits
sim_maize_pop <- function(){
  founder.pop.maize <- readRDS("inst/extdata/Maize.founder.population.preloaded.rds")
  SP <- AlphaSimR::SimParam$new(founder.pop.maize)
  traitcor <- matrix(c(1,-0.5,-0.5, 1), ncol = 2, byrow = T)
  SP$addTraitA(nQtlPerChr = 5, name = c("PlantHeight", "StemDiameter"),
               mean = c(150, 30), var = c(80, 10), corA = traitcor)
  qtl.map <- AlphaSimR::getQtlMap(trait = 1, simParam = SP)
  SP$restrSegSites(excludeQtl = qtl.map$id)
  ### Add the 1st trait, oligogenic and non correlated to other traits
  SP$addTraitA(nQtlPerChr = 2, name = "TasselLength",
               mean = 15, var = 5)
  
  ### Create the base population
  pop.maize <- AlphaSimR::newPop(founder.pop.maize, simParam = SP)
  pop.maize.fun <- pop.maize
  out_list <- list(SP = SP, pop.maize = pop.maize, pop.maize.fun = pop.maize.fun)
  return(out_list)
}

### Set phenotypes by defining heritabilities hence, error Var(e)
# pop <- setPheno(pop, h2 = c(0.9, 0.7, 0.8)) # Tassel length, height, and StemDiameter
###########################################################################################


####### Avocado #########################################################################
# ## Create, save, and preload a founder population for Avocado
# founder.pop <- runMacs(nInd = 100, nChr = 12, segSites = 10,
#                        species = "GENERIC", inbred = T)
# # saveRDS(founder.pop, "R/Avocado.founder.population.preloaded.rds")

### Add the 1st trait, oligogenic and non correlated to other traits
sim_avocado_pop <- function(){
  founder.pop.avocado <- readRDS("inst/extdata/Avocado.founder.population.preloaded.rds")
  SP.avocado <- AlphaSimR::SimParam$new(founder.pop.avocado)
  SP.avocado$addTraitA(nQtlPerChr = 2, name = "FruitWidth",
                       mean = 8, var = 2)
  qtl.map.avocado <- AlphaSimR::getQtlMap(trait = 1, simParam = SP.avocado)
  SP.avocado$restrSegSites(excludeQtl = qtl.map.avocado$id)
  
  ### Adding two correlated traits
  traitcor.avocado <- matrix(c(1,0.3,0.3,1), ncol = 2, byrow = T)
  SP.avocado$addTraitA(nQtlPerChr = 2, name = c("FruitLength", "PitSize"),
                       mean = c(12, 3), var = c(3, 2), corA = traitcor.avocado)
  
  ### Create the base population
  pop.avocado <- AlphaSimR::newPop(founder.pop.avocado, simParam = SP.avocado)
  out_lst <- list(pop.avocado = pop.avocado, SP.avocado = SP.avocado)
  return(out_lst)
}
###########################################################################################


####### Strawberry #########################################################################
# ## Create, save, and preload a founder population for Strawberry
# founder.pop <- runMacs(nInd = 100, nChr = 28, segSites = 5,
#                        species = "GENERIC", inbred = F)
# saveRDS(founder.pop, "R/Strawberry.founder.population.preloaded.rds")


### Creates a container for storing simulation parameters for the founder population


### Add the 1st trait, oligogenic and non correlated to other traits
sim_strawb_pop<- function(){
  founder.pop.strawberry <- readRDS("inst/extdata/Strawberry.founder.population.preloaded.rds")
  SP.strawberry <- AlphaSimR::SimParam$new(founder.pop.strawberry)
  traitcor.strawberry <- matrix(c(1,0.5,0.5, 1), ncol = 2, byrow = T)
  SP.strawberry$addTraitA(nQtlPerChr = 2, name = c("FruitLength", "FruitWidth"),
                          mean = c(8, 6), var = c(3, 2), corA = traitcor.strawberry)
  qtl.map.strawberry <- AlphaSimR::getQtlMap(trait = 1, simParam = SP.strawberry)
  SP.strawberry$restrSegSites(excludeQtl = qtl.map.strawberry$id)
  
  ### Adding two negatively correlated traits
  SP.strawberry$addTraitA(nQtlPerChr = 1, name = "SeedSize", mean = 3, var = 1.5)
  
  ### Create the base population
  pop.strawberry <- AlphaSimR::newPop(founder.pop.strawberry, simParam = SP.strawberry)
  out_lst <- list(SP.strawberry = SP.strawberry, pop.strawberry = pop.strawberry)
  return(out_lst)
}

### Set phenotypes by defining heritabilities hence, error Var(e)
# pop <- setPheno(pop, h2 = c(0.9, 0.7, 0.8)) # Tassel length, height, and StemDiameter
###########################################################################################
#Free some memory
# rm(list = c("qtl.map", "qtl.map.avocado", "qtl.map.strawberry"))
gc()
