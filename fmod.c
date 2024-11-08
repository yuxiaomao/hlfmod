#define HL_NAME(n) fmod_##n

#include <hl.h>
#include <fmod_studio.h>
#include <fmod_errors.h>

#define CHKERR(cmd, __default) { FMOD_RESULT __ret = (cmd); if( __ret != FMOD_OK ) { ReportFmodError(__ret,__LINE__); return __default; } }

#define _FSSYSTEM _ABSTRACT(FMOD_STUDIO_SYSTEM)
#define _FSYSTEM _ABSTRACT(FMOD_SYSTEM)
#define _FSEVENTDESCRIPTION _ABSTRACT(FMOD_STUDIO_EVENTDESCRIPTION)
#define _FSEVENTINSTANCE _ABSTRACT(FMOD_STUDIO_EVENTINSTANCE)
#define _FSBUS _ABSTRACT(FMOD_STUDIO_BUS)
#define _FSVCA _ABSTRACT(FMOD_STUDIO_VCA)
#define _FSBANK _ABSTRACT(FMOD_STUDIO_BANK)

IMPORT void hl_sys_print( vbyte *msg );
static void ReportFmodError( FMOD_RESULT err, int line ) {
	static char tmp[256];
	snprintf(tmp, 256, "FMOD Error (line %d): %s\n", line, FMOD_ErrorString(err));
	hl_sys_print((vbyte*)hl_to_utf16(tmp));
}

// ----- FMOD_STUDIO_SYSTEM -----

HL_PRIM FMOD_STUDIO_SYSTEM *HL_NAME(studio_system_create)() {
	FMOD_STUDIO_SYSTEM *system;
	CHKERR(FMOD_Studio_System_Create(&system, FMOD_VERSION), NULL);
	return system;
}

HL_PRIM bool HL_NAME(studio_system_initialize)(FMOD_STUDIO_SYSTEM *system, int maxchannels, int studioflags, int coreflags, void *extradriverdata) {
	CHKERR(FMOD_Studio_System_Initialize(system, maxchannels, studioflags, coreflags, extradriverdata), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_release)(FMOD_STUDIO_SYSTEM *system) {
	CHKERR(FMOD_Studio_System_Release(system), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_update)(FMOD_STUDIO_SYSTEM *system) {
	CHKERR(FMOD_Studio_System_Update(system), false);
	return true;
}

HL_PRIM FMOD_SYSTEM *HL_NAME(studio_system_get_core_system)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_SYSTEM *core;
	CHKERR(FMOD_Studio_System_GetCoreSystem(system, &core), NULL);
	return core;
}

HL_PRIM FMOD_STUDIO_EVENTDESCRIPTION *HL_NAME(studio_system_get_event)(FMOD_STUDIO_SYSTEM *system, const char *pathOrId) {
	FMOD_STUDIO_EVENTDESCRIPTION *ed;
	CHKERR(FMOD_Studio_System_GetEvent(system, pathOrId, &ed), NULL);
	return ed;
}

HL_PRIM FMOD_STUDIO_BUS *HL_NAME(studio_system_get_bus)(FMOD_STUDIO_SYSTEM *system, const char *pathOrId) {
	FMOD_STUDIO_BUS *bus;
	CHKERR(FMOD_Studio_System_GetBus(system, pathOrId, &bus), NULL);
	return bus;
}

HL_PRIM FMOD_STUDIO_VCA *HL_NAME(studio_system_get_vca)(FMOD_STUDIO_SYSTEM *system, const char *pathOrId) {
	FMOD_STUDIO_VCA *vca;
	CHKERR(FMOD_Studio_System_GetVCA(system, pathOrId, &vca), NULL);
	return vca;
}

HL_PRIM float HL_NAME(studio_system_get_parameter_by_name)(FMOD_STUDIO_SYSTEM *system, const char *name) {
	float finalvalue;
	CHKERR(FMOD_Studio_System_GetParameterByName(system, name, NULL, &finalvalue), 0);
	return finalvalue;
}

HL_PRIM bool HL_NAME(studio_system_set_parameter_by_name)(FMOD_STUDIO_SYSTEM *system, const char *name, float value, bool ignoreseekspeed) {
	CHKERR(FMOD_Studio_System_SetParameterByName(system, name, value, ignoreseekspeed), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_set_parameter_by_name_with_label)(FMOD_STUDIO_SYSTEM *system, const char *name, const char *label, bool ignoreseekspeed) {
	CHKERR(FMOD_Studio_System_SetParameterByNameWithLabel(system, name, label, ignoreseekspeed), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_set_listener_attributes)(FMOD_STUDIO_SYSTEM *system, int index, FMOD_3D_ATTRIBUTES *attributes, FMOD_VECTOR *attenuationposition) {
	CHKERR(FMOD_Studio_System_SetListenerAttributes(system, index, attributes, attenuationposition), false);
	return true;
}

HL_PRIM FMOD_STUDIO_BANK *HL_NAME(studio_system_load_bank_file)(FMOD_STUDIO_SYSTEM *system, const char *filename, int flags) {
	FMOD_STUDIO_BANK *bank;
	CHKERR(FMOD_Studio_System_LoadBankFile(system, filename, flags, &bank), NULL);
	return bank;
}

HL_PRIM bool HL_NAME(studio_system_flush_commands)(FMOD_STUDIO_SYSTEM *system) {
	CHKERR(FMOD_Studio_System_FlushCommands(system), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_system_flush_sample_loading)(FMOD_STUDIO_SYSTEM *system) {
	CHKERR(FMOD_Studio_System_FlushSampleLoading(system), false);
	return true;
}

HL_PRIM float HL_NAME(studio_system_get_cpu_usage)(FMOD_STUDIO_SYSTEM *system) {
	FMOD_STUDIO_CPU_USAGE usage;
	CHKERR(FMOD_Studio_System_GetCPUUsage(system, &usage, NULL), 0);
	return usage.update;
}

DEFINE_PRIM(_FSSYSTEM, studio_system_create, _NO_ARG);
DEFINE_PRIM(_BOOL, studio_system_initialize, _FSSYSTEM _I32 _I32 _I32 _DYN);
DEFINE_PRIM(_BOOL, studio_system_release, _FSSYSTEM);
DEFINE_PRIM(_BOOL, studio_system_update, _FSSYSTEM);
DEFINE_PRIM(_FSYSTEM, studio_system_get_core_system, _FSSYSTEM);
DEFINE_PRIM(_FSEVENTDESCRIPTION, studio_system_get_event, _FSSYSTEM _BYTES);
DEFINE_PRIM(_FSBUS, studio_system_get_bus, _FSSYSTEM _BYTES);
DEFINE_PRIM(_FSVCA, studio_system_get_vca, _FSSYSTEM _BYTES);
DEFINE_PRIM(_F32, studio_system_get_parameter_by_name, _FSSYSTEM _BYTES);
DEFINE_PRIM(_BOOL, studio_system_set_parameter_by_name, _FSSYSTEM _BYTES _F32 _BOOL);
DEFINE_PRIM(_BOOL, studio_system_set_parameter_by_name_with_label, _FSSYSTEM _BYTES _BYTES _BOOL);
DEFINE_PRIM(_BOOL, studio_system_set_listener_attributes, _FSSYSTEM _I32 _STRUCT _STRUCT);
DEFINE_PRIM(_FSBANK, studio_system_load_bank_file, _FSSYSTEM _BYTES _I32);
DEFINE_PRIM(_BOOL, studio_system_flush_commands, _FSSYSTEM);
DEFINE_PRIM(_BOOL, studio_system_flush_sample_loading, _FSSYSTEM);
DEFINE_PRIM(_F32, studio_system_get_cpu_usage, _FSSYSTEM);

// ----- FMOD_STUDIO_EVENTDESCRIPTION -----

HL_PRIM bool HL_NAME(studio_eventdescription_is_valid)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	return FMOD_Studio_EventDescription_IsValid(ed);
}

HL_PRIM int HL_NAME(studio_eventdescription_get_path)(FMOD_STUDIO_EVENTDESCRIPTION *ed, char *path, int size) {
	int retrieved = 0;
	CHKERR(FMOD_Studio_EventDescription_GetPath(ed, path, size, &retrieved), 0);
	return retrieved;
}

HL_PRIM int HL_NAME(studio_eventdescription_get_length)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	int length = 0;
	CHKERR(FMOD_Studio_EventDescription_GetLength(ed, &length), 0);
	return length;
}

HL_PRIM float HL_NAME(studio_eventdescription_get_min_distance)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	float mind, maxd;
	CHKERR(FMOD_Studio_EventDescription_GetMinMaxDistance(ed, &mind, &maxd), 0);
	return mind;
}

HL_PRIM float HL_NAME(studio_eventdescription_get_max_distance)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	float mind, maxd;
	CHKERR(FMOD_Studio_EventDescription_GetMinMaxDistance(ed, &mind, &maxd), 0);
	return maxd;
}

HL_PRIM float HL_NAME(studio_eventdescription_get_sound_size)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	float size;
	CHKERR(FMOD_Studio_EventDescription_GetSoundSize(ed, &size), 0);
	return size;
}

HL_PRIM bool HL_NAME(studio_eventdescription_is_snapshot)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	bool b = false;
	CHKERR(FMOD_Studio_EventDescription_IsSnapshot(ed, &b), false);
	return b;
}

HL_PRIM bool HL_NAME(studio_eventdescription_is_oneshot)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	bool b = false;
	CHKERR(FMOD_Studio_EventDescription_IsOneshot(ed, &b), false);
	return b;
}

HL_PRIM bool HL_NAME(studio_eventdescription_is_stream)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	bool b = false;
	CHKERR(FMOD_Studio_EventDescription_IsStream(ed, &b), false);
	return b;
}

HL_PRIM bool HL_NAME(studio_eventdescription_is3d)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	bool b = false;
	CHKERR(FMOD_Studio_EventDescription_Is3D(ed, &b), false);
	return b;
}

HL_PRIM bool HL_NAME(studio_eventdescription_is_doppler_enabled)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	bool b = false;
	CHKERR(FMOD_Studio_EventDescription_IsDopplerEnabled(ed, &b), false);
	return b;
}

HL_PRIM FMOD_STUDIO_EVENTINSTANCE *HL_NAME(studio_eventdescription_create_instance)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	FMOD_STUDIO_EVENTINSTANCE *ei;
	CHKERR(FMOD_Studio_EventDescription_CreateInstance(ed, &ei), NULL);
	return ei;
}

HL_PRIM bool HL_NAME(studio_eventdescription_load_sample_data)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	CHKERR(FMOD_Studio_EventDescription_LoadSampleData(ed), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventdescription_unload_sample_data)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	CHKERR(FMOD_Studio_EventDescription_UnloadSampleData(ed), false);
	return true;
}

HL_PRIM int HL_NAME(studio_eventdescription_get_loading_state)(FMOD_STUDIO_EVENTDESCRIPTION *ed) {
	FMOD_STUDIO_LOADING_STATE state;
	CHKERR(FMOD_Studio_EventDescription_GetSampleLoadingState(ed, &state), FMOD_STUDIO_LOADING_STATE_ERROR);
	return state;
}

DEFINE_PRIM(_BOOL, studio_eventdescription_is_valid, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_I32, studio_eventdescription_get_path, _FSEVENTDESCRIPTION _BYTES _I32);
DEFINE_PRIM(_I32, studio_eventdescription_get_length, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_F32, studio_eventdescription_get_min_distance, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_F32, studio_eventdescription_get_max_distance, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_F32, studio_eventdescription_get_sound_size, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_is_snapshot, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_is_oneshot, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_is_stream, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_is3d, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_is_doppler_enabled, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_FSEVENTINSTANCE, studio_eventdescription_create_instance, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_load_sample_data, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_BOOL, studio_eventdescription_unload_sample_data, _FSEVENTDESCRIPTION);
DEFINE_PRIM(_I32, studio_eventdescription_get_loading_state, _FSEVENTDESCRIPTION);

// ----- FMOD_STUDIO_EVENTINSTANCE -----

HL_PRIM bool HL_NAME(studio_eventinstance_is_valid)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	return FMOD_Studio_EventInstance_IsValid(ei);
}

HL_PRIM FMOD_STUDIO_SYSTEM *HL_NAME(studio_eventinstance_get_system)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	FMOD_STUDIO_SYSTEM *system;
	CHKERR(FMOD_Studio_EventInstance_GetSystem(ei, &system), NULL);
	return system;
}

HL_PRIM FMOD_3D_ATTRIBUTES *HL_NAME(studio_eventinstance_get_3d_attributes)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	FMOD_3D_ATTRIBUTES *attributes = {0};
	CHKERR(FMOD_Studio_EventInstance_Get3DAttributes(ei, attributes), NULL);
	return attributes;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_3d_attributes)(FMOD_STUDIO_EVENTINSTANCE *ei, FMOD_3D_ATTRIBUTES *attributes) {
	CHKERR(FMOD_Studio_EventInstance_Set3DAttributes(ei, attributes), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventinstance_start)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	CHKERR(FMOD_Studio_EventInstance_Start(ei), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventinstance_stop)(FMOD_STUDIO_EVENTINSTANCE *ei, int mode) {
	CHKERR(FMOD_Studio_EventInstance_Stop(ei, mode), false);
	return true;
}

HL_PRIM int HL_NAME(studio_eventinstance_get_timeline_position)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	int position = 0;
	CHKERR(FMOD_Studio_EventInstance_GetTimelinePosition(ei, &position), 0);
	return position;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_timeline_position)(FMOD_STUDIO_EVENTINSTANCE *ei, int position) {
	CHKERR(FMOD_Studio_EventInstance_SetTimelinePosition(ei, position), false);
	return true;
}

HL_PRIM int HL_NAME(studio_eventinstance_get_playback_state)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	FMOD_STUDIO_PLAYBACK_STATE state;
	CHKERR(FMOD_Studio_EventInstance_GetPlaybackState(ei, &state), -1);
	return state;
}

HL_PRIM bool HL_NAME(studio_eventinstance_release)(FMOD_STUDIO_EVENTINSTANCE *ei) {
	CHKERR(FMOD_Studio_EventInstance_Release(ei), false);
	return true;
}

HL_PRIM float HL_NAME(studio_eventinstance_get_parameter_by_name)(FMOD_STUDIO_EVENTINSTANCE *ei, const char *name) {
	float finalvalue;
	CHKERR(FMOD_Studio_EventInstance_GetParameterByName(ei, name, NULL, &finalvalue), 0);
	return finalvalue;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_parameter_by_name)(FMOD_STUDIO_EVENTINSTANCE *ei, const char *name, float value, bool ignoreseekspeed) {
	CHKERR(FMOD_Studio_EventInstance_SetParameterByName(ei, name, value, ignoreseekspeed), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_parameter_by_name_with_label)(FMOD_STUDIO_EVENTINSTANCE *ei, const char *name, const char *label, bool ignoreseekspeed) {
	CHKERR(FMOD_Studio_EventInstance_SetParameterByNameWithLabel(ei, name, label, ignoreseekspeed), false);
	return true;
}

typedef struct
{
	hl_type *t;
	FMOD_STUDIO_SYSTEM *studioSystem;
	FMOD_SYSTEM *coreSystem;
	const char *dialogueKey;
} fmod_programmer_sound_context;

// Used outside of hl thread
#define CHKERR_FMOD(cmd) { FMOD_RESULT __ret = (cmd); if( __ret != FMOD_OK ) { return __ret; } }

FMOD_RESULT F_CALL programmerSoundCallback(FMOD_STUDIO_EVENT_CALLBACK_TYPE type, FMOD_STUDIO_EVENTINSTANCE* ei, void *parameters)
{
	if (type == FMOD_STUDIO_EVENT_CALLBACK_CREATE_PROGRAMMER_SOUND)
	{
		FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES* props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES*)parameters;

		// Get our context from the event instance user data
		fmod_programmer_sound_context* context = NULL;
		CHKERR_FMOD( FMOD_Studio_EventInstance_GetUserData(ei, (void**)&context) );

		// Find the audio file in the audio table with the key
		FMOD_STUDIO_SOUND_INFO info;
		CHKERR_FMOD( FMOD_Studio_System_GetSoundInfo(context->studioSystem, context->dialogueKey, &info) );

		FMOD_SOUND* sound = NULL;
		CHKERR_FMOD( FMOD_System_CreateSound(context->coreSystem, info.name_or_data, FMOD_LOOP_NORMAL | FMOD_CREATECOMPRESSEDSAMPLE | FMOD_NONBLOCKING | info.mode, &info.exinfo, &sound) );

		// Pass the sound to FMOD
		props->sound = sound;
		props->subsoundIndex = info.subsoundindex;
	}
	else if (type == FMOD_STUDIO_EVENT_CALLBACK_DESTROY_PROGRAMMER_SOUND)
	{
		FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES* props = (FMOD_STUDIO_PROGRAMMER_SOUND_PROPERTIES*)parameters;

		// Obtain the sound
		FMOD_SOUND* sound = props->sound;

		// Release the sound
		CHKERR_FMOD( FMOD_Sound_Release(sound) );
	}
	return FMOD_OK;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_callback)(FMOD_STUDIO_EVENTINSTANCE *ei, int callbackmask) {
	CHKERR(FMOD_Studio_EventInstance_SetCallback(ei, programmerSoundCallback, callbackmask), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_eventinstance_set_user_data)(FMOD_STUDIO_EVENTINSTANCE *ei, void *userdata) {
	CHKERR(FMOD_Studio_EventInstance_SetUserData(ei, userdata), false);
	return true;
}

DEFINE_PRIM(_BOOL, studio_eventinstance_is_valid, _FSEVENTINSTANCE);
DEFINE_PRIM(_FSSYSTEM, studio_eventinstance_get_system, _FSEVENTINSTANCE);
DEFINE_PRIM(_STRUCT, studio_eventinstance_get_3d_attributes, _FSEVENTINSTANCE);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_3d_attributes, _FSEVENTINSTANCE _STRUCT);
DEFINE_PRIM(_BOOL, studio_eventinstance_start, _FSEVENTINSTANCE);
DEFINE_PRIM(_BOOL, studio_eventinstance_stop, _FSEVENTINSTANCE _I32);
DEFINE_PRIM(_I32, studio_eventinstance_get_timeline_position, _FSEVENTINSTANCE);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_timeline_position, _FSEVENTINSTANCE _I32);
DEFINE_PRIM(_I32, studio_eventinstance_get_playback_state, _FSEVENTINSTANCE);
DEFINE_PRIM(_BOOL, studio_eventinstance_release, _FSEVENTINSTANCE);
DEFINE_PRIM(_F32, studio_eventinstance_get_parameter_by_name, _FSEVENTINSTANCE _BYTES);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_parameter_by_name, _FSEVENTINSTANCE _BYTES _F32 _BOOL);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_parameter_by_name_with_label, _FSEVENTINSTANCE _BYTES _BYTES _BOOL);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_callback, _FSEVENTINSTANCE _I32);
DEFINE_PRIM(_BOOL, studio_eventinstance_set_user_data, _FSEVENTINSTANCE _DYN);

// ----- FMOD_STUDIO_BUS -----

HL_PRIM bool HL_NAME(studio_bus_is_valid)(FMOD_STUDIO_BUS *bus) {
	return FMOD_Studio_Bus_IsValid(bus);
}

HL_PRIM float HL_NAME(studio_bus_get_volume)(FMOD_STUDIO_BUS *bus) {
	float finalvalue;
	CHKERR(FMOD_Studio_Bus_GetVolume(bus, NULL, &finalvalue), 0);
	return finalvalue;
}

HL_PRIM bool HL_NAME(studio_bus_set_volume)(FMOD_STUDIO_BUS *bus, float volume) {
	CHKERR(FMOD_Studio_Bus_SetVolume(bus, volume), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_bus_get_paused)(FMOD_STUDIO_BUS *bus) {
	FMOD_BOOL paused;
	CHKERR(FMOD_Studio_Bus_GetPaused(bus, &paused), false);
	return paused;
}

HL_PRIM bool HL_NAME(studio_bus_set_paused)(FMOD_STUDIO_BUS *bus, bool paused) {
	CHKERR(FMOD_Studio_Bus_SetPaused(bus, paused), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_bus_get_mute)(FMOD_STUDIO_BUS *bus) {
	FMOD_BOOL mute;
	CHKERR(FMOD_Studio_Bus_GetMute(bus, &mute), false);
	return mute;
}

HL_PRIM bool HL_NAME(studio_bus_set_mute)(FMOD_STUDIO_BUS *bus, bool mute) {
	CHKERR(FMOD_Studio_Bus_SetMute(bus, mute), false);
	return true;
}

DEFINE_PRIM(_BOOL, studio_bus_is_valid, _FSBUS);
DEFINE_PRIM(_F32, studio_bus_get_volume, _FSBUS);
DEFINE_PRIM(_BOOL, studio_bus_set_volume, _FSBUS _F32);
DEFINE_PRIM(_BOOL, studio_bus_get_paused, _FSBUS);
DEFINE_PRIM(_BOOL, studio_bus_set_paused, _FSBUS _BOOL);
DEFINE_PRIM(_BOOL, studio_bus_get_mute, _FSBUS);
DEFINE_PRIM(_BOOL, studio_bus_set_mute, _FSBUS _BOOL);

// ----- FMOD_STUDIO_VCA -----

HL_PRIM bool HL_NAME(studio_vca_is_valid)(FMOD_STUDIO_VCA *vca) {
	return FMOD_Studio_VCA_IsValid(vca);
}

HL_PRIM float HL_NAME(studio_vca_get_volume)(FMOD_STUDIO_VCA *vca) {
	float finalvalue;
	CHKERR(FMOD_Studio_VCA_GetVolume(vca, NULL, &finalvalue), 0);
	return finalvalue;
}

HL_PRIM bool HL_NAME(studio_vca_set_volume)(FMOD_STUDIO_VCA *vca, float volume) {
	CHKERR(FMOD_Studio_VCA_SetVolume(vca, volume), false);
	return true;
}

DEFINE_PRIM(_BOOL, studio_vca_is_valid, _FSVCA);
DEFINE_PRIM(_F32, studio_vca_get_volume, _FSVCA);
DEFINE_PRIM(_BOOL, studio_vca_set_volume, _FSVCA _F32);

// ----- FMOD_STUDIO_BANK -----

HL_PRIM bool HL_NAME(studio_bank_is_valid)(FMOD_STUDIO_BANK *bank) {
	return FMOD_Studio_Bank_IsValid(bank);
}

HL_PRIM bool HL_NAME(studio_bank_unload)(FMOD_STUDIO_BANK *bank) {
	CHKERR(FMOD_Studio_Bank_Unload(bank), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_bank_load_sample_data)(FMOD_STUDIO_BANK *bank) {
	CHKERR(FMOD_Studio_Bank_LoadSampleData(bank), false);
	return true;
}

HL_PRIM bool HL_NAME(studio_bank_unload_sample_data)(FMOD_STUDIO_BANK *bank) {
	CHKERR(FMOD_Studio_Bank_UnloadSampleData(bank), false);
	return true;
}

HL_PRIM int HL_NAME(studio_bank_get_loading_state)(FMOD_STUDIO_BANK *bank) {
	FMOD_STUDIO_LOADING_STATE state;
	CHKERR(FMOD_Studio_Bank_GetLoadingState(bank, &state), FMOD_STUDIO_LOADING_STATE_ERROR);
	return state;
}

HL_PRIM int HL_NAME(studio_bank_get_sample_loading_state)(FMOD_STUDIO_BANK *bank) {
	FMOD_STUDIO_LOADING_STATE state;
	CHKERR(FMOD_Studio_Bank_GetSampleLoadingState(bank, &state), FMOD_STUDIO_LOADING_STATE_ERROR);
	return state;
}

HL_PRIM int HL_NAME(studio_bank_get_event_count)(FMOD_STUDIO_BANK *bank) {
	int count;
	CHKERR(FMOD_Studio_Bank_GetEventCount(bank, &count), 0);
	return count;
}

HL_PRIM int HL_NAME(studio_bank_get_event_list)(FMOD_STUDIO_BANK *bank, varray *arr) {
	int capacity = arr->size;
	int count = 0;
	FMOD_STUDIO_EVENTDESCRIPTION **arr1 = malloc(sizeof(FMOD_STUDIO_EVENTDESCRIPTION *) * capacity);
	CHKERR(FMOD_Studio_Bank_GetEventList(bank, arr1, capacity, &count), 0);
	for( int i = 0; i < count; i++ ) {
		hl_aptr(arr, FMOD_STUDIO_EVENTDESCRIPTION *)[i] = arr1[i];
	}
	free(arr1);
	return count;
}

DEFINE_PRIM(_BOOL, studio_bank_is_valid, _FSBANK);
DEFINE_PRIM(_BOOL, studio_bank_unload, _FSBANK);
DEFINE_PRIM(_BOOL, studio_bank_load_sample_data, _FSBANK);
DEFINE_PRIM(_BOOL, studio_bank_unload_sample_data, _FSBANK);
DEFINE_PRIM(_I32, studio_bank_get_loading_state, _FSBANK);
DEFINE_PRIM(_I32, studio_bank_get_sample_loading_state, _FSBANK);
DEFINE_PRIM(_I32, studio_bank_get_event_count, _FSBANK);
DEFINE_PRIM(_I32, studio_bank_get_event_list, _FSBANK _ARR);
