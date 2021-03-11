from libc.stdlib cimport malloc, calloc, free
cimport pyquest.quest_interface as quest
from pyquest.quest_interface cimport qreal, OP_TYPES, Qureg, pauliOpType, QuESTEnv
from pyquest.quest_interface cimport ComplexMatrix2, ComplexMatrix4, ComplexMatrixN
from pyquest.quest_interface cimport createComplexMatrixN, destroyComplexMatrixN
cimport numpy as np


cdef class BaseOperator:
    cdef int TYPE
    cdef int apply_to(self, Qureg c_register) except -1


cdef class GlobalOperator(BaseOperator):
    pass


cdef class ControlledOperator(BaseOperator):
    cdef int _num_controls
    cdef int *_controls


cdef class SingleQubitOperator(ControlledOperator):
    cdef int _target


cdef class MultiQubitOperator(ControlledOperator):
    cdef int _num_targets
    cdef int *_targets


cdef class MatrixOperator(MultiQubitOperator):
    cdef void *_matrix
    cdef qreal **_real
    cdef qreal **_imag
    cdef _create_array_property(self)
    cdef _numpy_array_to_matrix_attribute(self, np.ndarray arr)
    cdef _copy_generic_array(self, np.ndarray arr)
    cdef _copy_single_array(self, float[:, :] arr)
    cdef _copy_double_array(self, double[:, :] arr)
    cdef _copy_longdouble_array(self, long double[:, :] arr)
    cdef _copy_csingle_array(self, float complex[:, :] arr)
    cdef _copy_cdouble_array(self, double complex[:, :] arr)
    cdef _copy_clongdouble_array(self, long double complex[:, :] arr)


cdef class DiagonalOperator(GlobalOperator):
    pass


cdef class PauliProduct(GlobalOperator):
    cdef int _num_qubits
    cdef list _pauli_terms
    cdef qreal _coefficient
    cdef int *_pauli_codes


cdef class PauliSum(GlobalOperator):
    cdef int _min_qubits
    cdef int _num_qubits
    cdef int _num_terms
    cdef int *_all_pauli_codes
    cdef qreal *_coefficients
    cdef list _pauli_terms


cdef class TrotterCircuit(GlobalOperator):
    pass
