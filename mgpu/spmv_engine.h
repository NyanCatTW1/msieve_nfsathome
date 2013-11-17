/* simple DSO interface for sparse matrix multiply */

#ifndef _SPMV_ENGINE_H_
#define _SPMV_ENGINE_H_

#include <stdlib.h>
#include <cuda.h>

#ifdef __cplusplus
extern "C"
{
#endif

typedef struct {
	int num_rows;
	int num_col_entries;
	CUdeviceptr vector_in;    /* uint64 */
	CUdeviceptr vector_out;    /* uint64 */
	CUdeviceptr col_entries;    /* uint32 */
	CUdeviceptr row_entries;    /* uint32 */
} spmv_data_t;

typedef void (*spmv_engine_init_func)(int which_gpu);

typedef void (*spmv_engine_free_func)(void);

typedef int (*spmv_engine_preprocess_func)(spmv_data_t * spmv_data);

typedef void (*spmv_engine_run_func)(int spmv_preprocess,
				spmv_data_t * spmv_data);

#ifdef __cplusplus
}
#endif

#endif /* !_SPMV_ENGINE_H_ */
