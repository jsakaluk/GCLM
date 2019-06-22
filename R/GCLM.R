#' A Function That Writes, Saves, and Exports Syntax for
#' Fitting Generalized Cross-Lagged Panel Models (Zyphur et al., 2019)
#'
#' This function takes the outputted object from dyadVarNames()
#' and automatically writes, returns, and exports (.txt) lavaan() syntax
#' for specifying dyadic configural, loading, and intercept invariant
#' measurement models for either a specified X or Y factor.
#' @param xvar item stem (and delimeter, if present) for x variables
#' @param yvar item stem (and delimeter, if present) for y variables
#' @param waves number of waves to model (i.e., number following each item stem)
#' @return character object of lavaan script that can be passed immediately to
#' lavaan functions, while also exporting to current working directory
#' @export
#' @examples
#' base.model = GCLM(xvar = "sacrifice", yvar = "satisfaction", waves = 5)

GCLM <- function(xvar, yvar, waves){
  #Create list of xvars over time
  xvars = list()
  for (i in 1:waves) {
    xvars[[i]]=sprintf("%s%s", xvar, i)
  }
  #Create list of yvars over time
   yvars = list()
  for (i in 1:waves) {
    yvars[[i]]=sprintf("%s%s", yvar, i)
  }
   #Unit effects syntax
   eta_x = "eta_x =~"
   eta.x = paste(eta_x,paste(xvars, collapse = "+"))
   ext_y = "eta_y =~"
   eta.y = paste(ext_y,paste(yvars, collapse = "+"))

   #Impulse syntax
   ximp1 = list()
   ximp2 = list()
   yimp1 = list()
   yimp2 = list()
   for (i in 1:waves) {
     ximp1[[i]]=sprintf("u_x%s =~ %s%s",i, xvar, i)
     yimp1[[i]]=sprintf("u_y%s =~ %s%s",i, yvar, i)
     ximp2[[i]]=sprintf("%s%s ~~ 0*%s%s",xvar, i,xvar, i)
     yimp2[[i]]=sprintf("%s%s ~~ 0*%s%s",yvar, i,yvar, i)
   }

   ximp1 = paste(ximp1, collapse = " \n")
   ximp2 = paste(ximp2, collapse = " \n")
   yimp1 = paste(yimp1, collapse = " \n")
   yimp2 = paste(yimp2, collapse = " \n")

   #Regressions syntax
   xregs = c()
   yregs = c()
   for (i in 2:waves) {
     xregs[[i]]=sprintf("%s%s ~ a*%s%s + b*%s%s + c*u_x%s + d*u_y%s", xvar, i, xvar, i-1, yvar, i-1, i-1, i-1)
     yregs[[i]]=sprintf("%s%s ~ f*%s%s + g*%s%s + h*u_x%s + i*u_y%s", yvar, i, xvar, i-1, yvar, i-1, i-1, i-1)
   }
   xregs = paste(xregs)
   xregs = xregs[2:waves]
   xregs = paste(xregs, collapse = " \n")

   yregs = paste(yregs)
   yregs = yregs[2:waves]
   yregs = paste(yregs, collapse = " \n")

   #Co-movements Syntax
   comove = c()
   for (i in 1:waves) {
     comove[[i]]=sprintf("u_x%s ~~ u_y%s", i, i)
   }
   comove = paste(comove, collapse = " \n")

   #Restrictions syntax
   implist.x = c()
   implist.y = c()
   for (i in 1:waves) {
     implist.x[[i]]=sprintf("u_x%s",i)
     implist.y[[i]]=sprintf("u_y%s", i)
   }
   imps = c(implist.x, implist.y)
   varnum = waves*2
   restrict.list = c()
   for (i in 1:varnum) {
     restrict.list[[i]]=c(imps[i+1:varnum])
   }
   restrict.list <- lapply(restrict.list, function(x) x[!is.na(x)])

   store = c()
   for (i in 1:varnum) {
     store[[i]] = paste("0*",restrict.list[[i]],collapse = "+")
   }

   store = gsub(" ", "", store, fixed = TRUE)
   store[varnum]="NA"

   res = c()
   for (i in 1:varnum) {
     res[[i]]=sprintf("%s ~~ 0*eta_x + 0*eta_y + %s", imps[i], store[i])
   }
   res = gsub("+ NA", "", res, fixed = T)

   res = paste(res, collapse = " \n")

   #Script Creation Syntax
   script = sprintf("#unit effects\n%s\n%s\n\n#impulses\n%s\n%s\n%s\n%s\n\n#regressions\n%s\n%s\n\n#co-movements\n%s\n\n#restrictions\n%s", eta.x, eta.y, ximp1, ximp2, yimp1, yimp2, xregs, yregs, comove, res)
   cat(script,"\n", file = "test.txt")
   return(script)
}

