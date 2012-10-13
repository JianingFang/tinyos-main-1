plotFile <- F
argc <- length(commandArgs())
argStart <- 1 + which (commandArgs() == '--args')
library(plyr)
library(ggplot2)
library(RSQLite)

selectQ <- "SELECT 
node, dc FROM duty_cycle
WHERE node !=0
AND dc is not null
and node not in (select node from error_events)"

x <- c()
nx <- c()
xmin <- 0
xmax <- 2
for (i in seq(argStart, argc-1)){
  opt <- commandArgs()[i]
  val <- commandArgs()[i+1]
 
  if ( opt == '--ndb'){
    fn <- val
    lbl <- commandArgs()[i+2]
    con <- dbConnect(dbDriver("SQLite"), dbname=fn)
    tmp <- dbGetQuery(con, selectQ)
    print(paste("Loaded", length(tmp$node), "from", fn))
    if (length(tmp$node) > 0 ){
      tmp$label <- lbl
      tmp$fn <- fn
      nx <- rbind(nx, tmp)
    }
  }
  if ( opt == '--db'){
    fn <- val
    lbl <- commandArgs()[i+2]
    con <- dbConnect(dbDriver("SQLite"), dbname=fn)
    tmp <- dbGetQuery(con, selectQ)
    print(paste("Loaded", length(tmp$node), "from", fn))
    if (length(tmp$node) > 0 ){
      tmp$label <- lbl
      tmp$fn <- fn
      x <- rbind(x, tmp)
    }
  }

  if ( opt == '--pdf' ){
    plotFile=T
    pdf(val, width=9, height=6, title="PRR Comparison CDF")
  }
  if ( opt == '--png' ){
    plotFile=T
    png(val, width=9, height=6, units="in", res=200)
  }
  if (opt == '--xmin'){
    xmin <- as.numeric(val)
  }
  if (opt == '--xmax'){
    xmax <- as.numeric(val)
  }
  if (opt == '--labels'){
    labels <- val
  }
}
print("raw loaded")


# #TODO: what the hell: a few nodes have high duty cycle in several
# # tests, and it's really throwing off the figures
# # 3, 15, 19, 21, 58
# x <- x[x$node !=3,]
# x <- x[x$node !=15,]
# x <- x[x$node !=19,]
# x <- x[x$node !=21,]
# x <- x[x$node !=58,]

aggByNode <- ddply(x, .(label, node), summarise,
  dc=mean(dc),
  dc=sd(dc)
)
nAggByNode <- ddply(nx, .(label, node), summarise,
  dc=mean(dc),
  dc=sd(dc)
)
aggByNode <- merge(nAggByNode, aggByNode, by='node', suffixes=c('.ref', '.var'))

aggByNode$label <- aggByNode$label.var
aggByNode$dc <- aggByNode$dc.var/aggByNode$dc.ref

aggByLabel <- ddply(aggByNode, .(label), summarize,
  medOfMed=median(dc),
  meanOfMed=mean(dc)
)

#aggByNode <- aggByNode[aggByNode$label=="3",]
print(aggByLabel)
#What this next thing means:
#  group by label
#  prr = list of unique PRRs for group
#  ecdf = ecdf of PRRs for group applied to list of unique PRRs
#         for group
#  (ecdf returns a function, applying it to a PRR gives you its
#    cumulative density)
aggCDF <- ddply(aggByNode, .(label), summarize, 
  dc=unique(dc),
  ecdf=ecdf(dc)(unique(dc)))

# #TODO add end points at (0,0): this makes the plot barf (I think
# # that it wants observations for each group to be contiguous?
# for (lbl in unique(aggCDF$label)){
#   aggCDF <- rbind(aggCDF, c(lbl, 0, 0))
# }

if (labels == 'none'){
  print(
    ggplot(aggCDF, aes(x=dc, y=ecdf, color=label))
    + geom_line()
    + geom_vline(xintercept=c(1.0), linetype='dotted')
    + scale_y_continuous(limits=c(0,1.0))
    + scale_x_continuous(limits=c(xmin,xmax))
    + theme_bw()
  )
}

if (labels == 'bw'){
  print(
    ggplot(aggCDF, aes(x=dc, y=ecdf, color=label))
    + geom_line()
    + scale_y_continuous(limits=c(0,1.0))
    + scale_x_continuous(limits=c(xmin,xmax))
    + scale_colour_hue(name="Boundary Width")
    + geom_vline(xintercept=c(1.0), linetype='dotted')
    + theme_bw()
    + theme(legend.justification=c(0,1), legend.position=c(0,1))
  )
}

if (labels == 'sel'){
  print(
    ggplot(aggCDF, aes(x=dc, y=ecdf, color=label))
    + geom_line()
    + scale_y_continuous(limits=c(0,1.0))
    + scale_x_continuous(limits=c(xmin,xmax))
    + scale_colour_hue(name="Selection Method",
      breaks=c(0, 1, 2),
      labels=c('Last', 'Avg', 'Max'))
    + geom_vline(xintercept=c(1.0), linetype='dotted')
    + theme_bw()
    + theme(legend.justification=c(0,1), legend.position=c(0,1))
  )
}

if ( plotFile){
  g<-dev.off()
}

