fibonacci <- function(k){
  assert_that(k>= 0)
  if (k <= 1) {
    return (1)
  }else{
    return (fibonacci(k-1) + fibonacci(k-2))
  }
}
