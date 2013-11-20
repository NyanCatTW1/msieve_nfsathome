#include <stdio.h>
#include <vector>
#include <moderngpu.cuh>

#include "spmv_engine.h"

#if defined(_WIN32) || defined (_WIN64)
	#define SPMV_ENGINE_DECL __declspec(dllexport)
#else
	#define SPMV_ENGINE_DECL __attribute__((visibility("default")))
#endif

using namespace mgpu;

typedef unsigned int uint32;
typedef std::auto_ptr<SpmvPreprocessData> spmv_preprocess;

ContextPtr *local_ctx;

std::vector<spmv_preprocess *> preproc_list;

extern "C"
{

SPMV_ENGINE_DECL void 
spmv_engine_init(int which_gpu)
{
	local_ctx = new ContextPtr(CreateCudaDevice(which_gpu));
}

SPMV_ENGINE_DECL void 
spmv_engine_free(void)
{
	for (int i = 0; i < preproc_list.size(); i++)
		delete preproc_list[i];

	delete local_ctx;
}

SPMV_ENGINE_DECL int
spmv_engine_preprocess(spmv_data_t * data)
{
	int new_handle = preproc_list.size();
#if 0
	spmv_preprocess * new_ptr = new spmv_preprocess();

	SpmvPreprocessUnary<uint64, int *>(
			data->num_col_entries,
			(int *)data->row_entries,
			data->num_rows,
			true,
			new_ptr,
			**local_ctx);

	preproc_list.push_back(new_ptr);
#endif
	return new_handle;
}

SPMV_ENGINE_DECL void 
spmv_engine_run(int preprocess_handle, spmv_data_t * data)
{
#if 0
	SpmvUnaryApply<int *, uint64 *, uint64 *, uint64,
			bit_and<uint64>, bit_xor<uint64> > (
				**preproc_list[preprocess_handle],
				(int *)data->col_entries,
				(uint64 *)data->vector_in,
				(uint64 *)data->vector_out,
				(uint64)0,
				bit_xor<uint64>(),
				**local_ctx);
#else
       SpmvCsrUnary<int *, int *, uint64 *, uint64 *, uint64,
                        bit_xor<uint64> > (
                                (int *)data->col_entries,
                                data->num_col_entries,      
                                (int *)data->row_entries,         
                                data->num_rows,          
                                (uint64 *)data->vector_in,
                                true,
                                (uint64 *)data->vector_out,
                                (uint64)0,
                                bit_xor<uint64>(),
                                **local_ctx);

#endif
}

} // extern "C"
