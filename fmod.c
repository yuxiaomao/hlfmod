#define HL_NAME(n) fmod_##n

#include <hl.h>
#include <fmod_studio.h>
#include <fmod_errors.h>

#define CHKERR(__ret, __default) { if( __ret != FMOD_OK ) { ReportFmodError(__ret,__LINE__); return __default; } }

#define _FSSYSTEM _ABSTRACT(FMOD_STUDIO_SYSTEM)
#define _FSYSTEM _ABSTRACT(FMOD_SYSTEM)
#define _FSBANK _ABSTRACT(FMOD_STUDIO_BANK)
#define _FSEVENTDESCRIPTION _ABSTRACT(FMOD_STUDIO_EVENTDESCRIPTION)
#define _FSEVENTINSTANCE _ABSTRACT(FMOD_STUDIO_EVENTINSTANCE)

IMPORT void hl_sys_print( vbyte *msg );
static void ReportFmodError( FMOD_RESULT err, int line ) {
	static char tmp[256];
	snprintf(tmp, 256, "FMOD Error (line %d): %s\n", line, FMOD_ErrorString(err));
	hl_sys_print((vbyte*)hl_to_utf16(tmp));
}

// ----- FMOD_STUDIO_SYSTEM -----

HL_PRIM FMOD_STUDIO_SYSTEM *HL_NAME(studio_system_create)() {
	FMOD_STUDIO_SYSTEM *system;
	FMOD_RESULT res = FMOD_Studio_System_Create(&system, FMOD_VERSION);
	CHKERR(res, NULL);
	return system;
}

HL_PRIM bool HL_NAME(studio_system_initialize)(FMOD_STUDIO_SYSTEM *system, int maxchannels, int studioflags, int coreflags, void *extradriverdata) {
	FMOD_RESULT res = FMOD_Studio_System_Initialize(system, maxchannels, studioflags, coreflags, extradriverdata);
	CHKERR(res, false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_release)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_RESULT res = FMOD_Studio_System_Release(system);
	CHKERR(res, false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_update)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_RESULT res = FMOD_Studio_System_Update(system);
	CHKERR(res, false);
	return true;
}

HL_PRIM FMOD_SYSTEM *HL_NAME(studio_system_get_core_system)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_SYSTEM *core;
	FMOD_RESULT res = FMOD_Studio_System_GetCoreSystem(system, &core);
	CHKERR(res, NULL);
	return core;
}

HL_PRIM FMOD_STUDIO_EVENTDESCRIPTION *HL_NAME(studio_system_get_event)(FMOD_STUDIO_SYSTEM *system, const char *pathOrId) {
	FMOD_STUDIO_EVENTDESCRIPTION *ed;
	FMOD_RESULT res = FMOD_Studio_System_GetEvent(system, pathOrId, &ed);
	CHKERR(res, NULL);
	return ed;
}

HL_PRIM float HL_NAME(studio_system_get_parameter_by_name)(FMOD_STUDIO_SYSTEM *system, const char *name) {
	float finalvalue;
	FMOD_RESULT res = FMOD_Studio_System_GetParameterByName(system, name, NULL, &finalvalue);
	CHKERR(res, 0);
	return finalvalue;
}

HL_PRIM bool HL_NAME(studio_system_set_parameter_by_name)(FMOD_STUDIO_SYSTEM *system, const char *name, float value, bool ignoreseekspeed) {
	FMOD_RESULT res = FMOD_Studio_System_SetParameterByName(system, name, value, ignoreseekspeed);
	CHKERR(res, true);
	return false;
}

HL_PRIM bool HL_NAME(studio_system_set_parameter_by_name_with_label)(FMOD_STUDIO_SYSTEM *system, const char *name, const char *label, bool ignoreseekspeed) {
	FMOD_RESULT res = FMOD_Studio_System_SetParameterByNameWithLabel(system, name, label, ignoreseekspeed);
	CHKERR(res, true);
	return false;
}

HL_PRIM bool HL_NAME(studio_system_set_listener_attributes)(FMOD_STUDIO_SYSTEM *system, int index, FMOD_3D_ATTRIBUTES *attributes, FMOD_VECTOR *attenuationposition) {
	FMOD_RESULT res = FMOD_Studio_System_SetListenerAttributes(system, index, attributes, attenuationposition);
	CHKERR(res, true);
	return false;
}

HL_PRIM FMOD_STUDIO_BANK *HL_NAME(studio_system_load_bank_file)(FMOD_STUDIO_SYSTEM *system, const char *filename, int flags) {
	FMOD_STUDIO_BANK *bank;
	FMOD_RESULT res = FMOD_Studio_System_LoadBankFile(system, filename, flags, &bank);
	CHKERR(res, NULL);
	return bank;
}

HL_PRIM bool HL_NAME(studio_system_flush_commands)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_RESULT res = FMOD_Studio_System_FlushCommands(system);
	CHKERR(res, true);
	return false;
}

HL_PRIM bool HL_NAME(studio_system_flush_sample_loading)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_RESULT res = FMOD_Studio_System_FlushSampleLoading(system);
	CHKERR(res, true);
	return false;
}

DEFINE_PRIM(_FSSYSTEM, studio_system_create, _NO_ARG);
DEFINE_PRIM(_BOOL, studio_system_initialize, _FSSYSTEM _I32 _I32 _I32 _DYN);
DEFINE_PRIM(_BOOL, studio_system_release, _FSSYSTEM);
DEFINE_PRIM(_BOOL, studio_system_update, _FSSYSTEM);
DEFINE_PRIM(_FSYSTEM, studio_system_get_core_system, _FSSYSTEM);
DEFINE_PRIM(_FSEVENTDESCRIPTION, studio_system_get_event, _FSSYSTEM _BYTES);
DEFINE_PRIM(_F32, studio_system_get_parameter_by_name, _FSSYSTEM _BYTES);
DEFINE_PRIM(_BOOL, studio_system_set_parameter_by_name, _FSSYSTEM _BYTES _F32 _BOOL);
DEFINE_PRIM(_BOOL, studio_system_set_parameter_by_name_with_label, _FSSYSTEM _BYTES _BYTES _BOOL);
DEFINE_PRIM(_BOOL, studio_system_set_listener_attributes, _FSSYSTEM _I32 _STRUCT _STRUCT);
DEFINE_PRIM(_FSBANK, studio_system_load_bank_file, _FSSYSTEM _BYTES _I32);
DEFINE_PRIM(_BOOL, studio_system_flush_commands, _FSSYSTEM);
DEFINE_PRIM(_BOOL, studio_system_flush_sample_loading, _FSSYSTEM);

// ----- FMOD_STUDIO_EVENTDESCRIPTION -----

HL_PRIM FMOD_STUDIO_EVENTINSTANCE *HL_NAME(studio_eventdescription_create_instance)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	FMOD_STUDIO_EVENTINSTANCE *ei;
	FMOD_RESULT res = FMOD_Studio_EventDescription_CreateInstance(ed, &ei);
	CHKERR(res, NULL);
	return ei;
}

HL_PRIM bool HL_NAME(studio_eventdescription_load_sample_data)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	FMOD_RESULT res = FMOD_Studio_EventDescription_LoadSampleData(ed);
	CHKERR(res, false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventdescription_unload_sample_data)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	FMOD_RESULT res = FMOD_Studio_EventDescription_UnloadSampleData(ed);
	CHKERR(res, false);
	return true;
}

HL_PRIM int HL_NAME(studio_eventdescription_get_loading_state)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	FMOD_STUDIO_LOADING_STATE state;
	FMOD_RESULT res = FMOD_Studio_EventDescription_GetSampleLoadingState(ed, &state);
	CHKERR(res, FMOD_STUDIO_LOADING_STATE_ERROR);
	return state;
}

DEFINE_PRIM(_FSEVENTINSTANCE, studio_eventdescription_create_instance, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_load_sample_data, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_unload_sample_data, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_I32, studio_eventdescription_get_loading_state, _FSEVENTDESCRIPTION);

// ----- FMOD_STUDIO_EVENTINSTANCE -----

HL_PRIM FMOD_3D_ATTRIBUTES *HL_NAME(studio_eventinstance_get_3d_attributes)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	FMOD_3D_ATTRIBUTES *attributes = {0};
	FMOD_RESULT res = FMOD_Studio_EventInstance_Get3DAttributes(ei, attributes);
	CHKERR(res, NULL);
	return attributes;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_3d_attributes)(FMOD_STUDIO_EVENTINSTANCE *ei, FMOD_3D_ATTRIBUTES *attributes) {
	FMOD_RESULT res = FMOD_Studio_EventInstance_Set3DAttributes(ei, attributes);
	CHKERR(res, true);
	return false;
}

HL_PRIM bool HL_NAME(studio_eventinstance_start)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	FMOD_RESULT res = FMOD_Studio_EventInstance_Start(ei);
	CHKERR(res, false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventinstance_release)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	FMOD_RESULT res = FMOD_Studio_EventInstance_Release(ei);
	CHKERR(res, false);
	return true;
}

HL_PRIM float HL_NAME(studio_eventinstance_get_parameter_by_name)(FMOD_STUDIO_EVENTINSTANCE *ei, const char *name) {
	float finalvalue;
	FMOD_RESULT res = FMOD_Studio_EventInstance_GetParameterByName(ei, name, NULL, &finalvalue);
	CHKERR(res, 0);
	return finalvalue;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_parameter_by_name)(FMOD_STUDIO_EVENTINSTANCE *ei, const char *name, float value, bool ignoreseekspeed) {
	FMOD_RESULT res = FMOD_Studio_EventInstance_SetParameterByName(ei, name, value, ignoreseekspeed);
	CHKERR(res, true);
	return false;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_parameter_by_name_with_label)(FMOD_STUDIO_EVENTINSTANCE *ei, const char *name, const char *label, bool ignoreseekspeed) {
	FMOD_RESULT res = FMOD_Studio_EventInstance_SetParameterByNameWithLabel(ei, name, label, ignoreseekspeed);
	CHKERR(res, true);
	return false;
}

DEFINE_PRIM(_STRUCT, studio_eventinstance_get_3d_attributes, _FSEVENTINSTANCE);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_3d_attributes, _FSEVENTINSTANCE _STRUCT);
DEFINE_PRIM(_BOOL, studio_eventinstance_start, _FSEVENTINSTANCE);
DEFINE_PRIM(_BOOL, studio_eventinstance_release, _FSEVENTINSTANCE);
DEFINE_PRIM(_F32, studio_eventinstance_get_parameter_by_name, _FSEVENTINSTANCE _BYTES);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_parameter_by_name, _FSEVENTINSTANCE _BYTES _F32 _BOOL);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_parameter_by_name_with_label, _FSEVENTINSTANCE _BYTES _BYTES _BOOL);

// ----- FMOD_STUDIO_BANK -----

HL_PRIM bool HL_NAME(studio_bank_unload)(FMOD_STUDIO_BANK *bank) {
	FMOD_RESULT res = FMOD_Studio_Bank_Unload(bank);
	CHKERR(res, false);
	return true;
}

HL_PRIM bool HL_NAME(studio_bank_load_sample_data)(FMOD_STUDIO_BANK *bank) {
	FMOD_RESULT res = FMOD_Studio_Bank_LoadSampleData(bank);
	CHKERR(res, false);
	return true;
}

HL_PRIM bool HL_NAME(studio_bank_unload_sample_data)(FMOD_STUDIO_BANK *bank) {
	FMOD_RESULT res = FMOD_Studio_Bank_UnloadSampleData(bank);
	CHKERR(res, false);
	return true;
}

HL_PRIM int HL_NAME(studio_bank_get_loading_state)(FMOD_STUDIO_BANK *bank) {
	FMOD_STUDIO_LOADING_STATE state;
	FMOD_RESULT res = FMOD_Studio_Bank_GetLoadingState(bank, &state);
	CHKERR(res, FMOD_STUDIO_LOADING_STATE_ERROR);
	return state;
}

HL_PRIM int HL_NAME(studio_bank_get_sample_loading_state)(FMOD_STUDIO_BANK *bank) {
	FMOD_STUDIO_LOADING_STATE state;
	FMOD_RESULT res = FMOD_Studio_Bank_GetSampleLoadingState(bank, &state);
	CHKERR(res, FMOD_STUDIO_LOADING_STATE_ERROR);
	return state;
}

DEFINE_PRIM(_BOOL, studio_bank_unload, _FSBANK);
DEFINE_PRIM(_BOOL, studio_bank_load_sample_data, _FSBANK);
DEFINE_PRIM(_BOOL, studio_bank_unload_sample_data, _FSBANK);
DEFINE_PRIM(_I32, studio_bank_get_loading_state, _FSBANK);
DEFINE_PRIM(_I32, studio_bank_get_sample_loading_state, _FSBANK);
