This RFC proposes gradually deprecating the non-unit strides on the vector.extract_strided_slice and vector.insert_strided_slice ops.

Currently, if a vector.extract_strided_slice or vector.insert_strided_slice is created with non-unit strides, there is a verification failure. This has been the case for 6 years, since inception https://github.com/llvm/llvm-project/commit/36469f7d2a6b14582eb18e860d61c2aa2c329e49

There is a fair amount of code like this upstream

```c++
[...]
if (stridedSliceOp.hasNonUnitStrides())
  return failure();
```

At this point I think it will be difficult to add support for strided slices, and I don't think there is a motivation to. Semantically, non-unit strides can often be represented by adding shape_casts. When the strides divide the sizes, it can be expessed as shape_cast(extract_strides_slice(shape_cast)) where the new extract_strided_slice has unit strides. Consider,

```mlir
// Using non-unit strides
%0 = vector.extract_strided_slice %arg0 {offsets = [1, 0], 
                                           sizes = [2, 4], 
                                         strides = [2, 2]} : vector<6x8xi8> to vector<2x4xi8>

// Equivalent vector, without using non-unit strides
%1 = vector.shape_cast %arg0 : vector<6x8xi8> to vector<3x2x4x2xi8>
%2 = vector.extract_strided_slice %1 {offsets = [0, 1, 0, 0], 
                                        sizes = [2, 1, 4, 1], 
                                      strides = [1, 1, 1, 1]} : vector<3x2x4x2xi8> to vector<2x1x4x1xi8>
%3 = vector.shape_cast %2 : vector<2x1x4x1xi8> to vector<2x4xi8>

my.assert %0 == %3
```

When the strides do not divide the sizes, it can be handled similarly, bu with an additional extract_strided_slice to split the initial tensor into one which is divisible by strides, and one with a single slice. 

