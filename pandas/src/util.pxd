from numpy cimport ndarray
cimport numpy as cnp

cdef extern from "numpy_helper.h":
    inline int is_integer_object(object)
    inline int is_float_object(object)
    inline int is_bool_object(object)
    inline int is_string_object(object)
    inline int assign_value_1d (ndarray, Py_ssize_t, object) except -1


cdef inline object get_value_at(ndarray arr, object loc):
    cdef:
        Py_ssize_t i, sz
        void* data_ptr
    if is_float_object(loc):
        casted = int(loc)
        if casted == loc:
            loc = casted
    i = <Py_ssize_t> loc
    sz = cnp.PyArray_SIZE(arr)

    if i < 0:
        i += sz
    elif i >= sz:
        raise IndexError('index out of bounds')
    data_ptr = cnp.PyArray_GETPTR1(arr, i)
    return cnp.PyArray_GETITEM(arr, data_ptr)

cdef inline set_value_at(ndarray arr, object loc, object value):
    cdef:
        Py_ssize_t i, sz
    if is_float_object(loc):
        casted = int(loc)
        if casted == loc:
            loc = casted
    i = <Py_ssize_t> loc
    sz = cnp.PyArray_SIZE(arr)

    if i < 0:
        i += sz
    elif i >= sz:
        raise IndexError('index out of bounds')

    assign_value_1d(arr, i, value)

cdef inline int is_contiguous(ndarray arr):
    return cnp.PyArray_CHKFLAGS(arr, cnp.NPY_C_CONTIGUOUS)