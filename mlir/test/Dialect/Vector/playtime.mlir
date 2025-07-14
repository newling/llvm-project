// mlir-opt --verify-diagnostics  playtime.mlir

// func.func @canonicalize_extract_shapecast_different_element_type()->vector<12xi128> {
//   %0 = llvm.mlir.constant(dense<0.000000e+00> : vector<12xf8E4M3FN>) : vector<12xi128>
//   %1 = vector.shape_cast %0 : vector<12xi128> to vector<1x12xi128>
//   %2 = vector.extract %1[0] : vector<12xi128> from vector<1x12xi128>
//   return %2 : vector<12xi128>
// }

func.func @canonicalize_extract_shapecast_different_element_type()->vector<1x1x12xf8E4M3FN> {
  %0 = arith.constant dense<0.000000e+00> : vector<12xf8E4M3FN>
  %1 = vector.shape_cast %0 : vector<12xf8E4M3FN> to vector<1x1x12xf8E4M3FN>
  return %1 : vector<1x1x12xf8E4M3FN>
}



func.func @foo() -> (f8E4M3FN, vector<f8E4M3FN>, vector<1xf8E4M3FN>) {
  %0 = arith.constant 0.0 : f8E4M3FN
  %1 = arith.constant dense<0.00> : vector<f8E4M3FN>
  %2 = arith.constant dense<0.000000e+00> : vector<1xf8E4M3FN>
  return %0, %1, %2 : f8E4M3FN, vector<f8E4M3FN>, vector<1xf8E4M3FN>
}

func.func @foo2() -> (f8E5M2, vector<f8E5M2>, vector<1xf8E5M2>) {
  %0 = arith.constant 0.0 : f8E5M2
  %1 = arith.constant dense<0.00> : vector<f8E5M2>
  %2 = arith.constant dense<0.000000e+00> : vector<1xf8E5M2>
  return %0, %1, %2 : f8E5M2, vector<f8E5M2>, vector<1xf8E5M2>
}

