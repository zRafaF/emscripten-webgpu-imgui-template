CC = emcc
CXX = em++
WEB_DIR = web
BUILD_DIR = ./build
EXE = $(WEB_DIR)/index.js
IMGUI_DIR = ./lib/imgui/
SRC_DIR = src
INCLUDE_DIR = include

# Find all .cpp files under src
SOURCES = $(wildcard $(SRC_DIR)/*.cpp)

# Find all .cpp files under imgui and imgui/backends
SOURCES += $(wildcard $(IMGUI_DIR)/*.cpp) $(wildcard $(IMGUI_DIR)/backends/*.cpp)

# Find all .h files under include
CPPFLAGS += -I$(IMGUI_DIR) -I$(IMGUI_DIR)/backends -I$(INCLUDE_DIR)

OBJS = $(addprefix $(BUILD_DIR)/, $(addsuffix .o, $(notdir $(basename $(SOURCES)))))

UNAME_S := $(shell uname -s)
EMS =

##---------------------------------------------------------------------
## EMSCRIPTEN OPTIONS
##---------------------------------------------------------------------

EMS += -s DISABLE_EXCEPTION_CATCHING=1
LDFLAGS += -s USE_GLFW=3 -s USE_WEBGPU=1
LDFLAGS += -s WASM=1 -s ALLOW_MEMORY_GROWTH=1 -s NO_EXIT_RUNTIME=0 -s ASSERTIONS=1

USE_FILE_SYSTEM ?= 0
ifeq ($(USE_FILE_SYSTEM), 0)
LDFLAGS += -s NO_FILESYSTEM=1
CPPFLAGS += -DIMGUI_DISABLE_FILE_FUNCTIONS
endif
ifeq ($(USE_FILE_SYSTEM), 1)
LDFLAGS += --no-heap-copy --preload-file ../../misc/fonts@/fonts
endif

##---------------------------------------------------------------------
## FINAL BUILD FLAGS
##---------------------------------------------------------------------

CPPFLAGS += -Wall -Wformat -Os $(EMS)
LDFLAGS += $(EMS)

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: $(IMGUI_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

$(BUILD_DIR)/%.o: $(IMGUI_DIR)/backends/%.cpp | $(BUILD_DIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

all: $(EXE)
	@echo Build complete for $(EXE)

$(WEB_DIR):
	mkdir $@

$(BUILD_DIR):
	mkdir $@

serve: all
	python3 -m http.server -d $(WEB_DIR) -b localhost

$(EXE): $(OBJS) | $(WEB_DIR)
	$(CXX) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -f $(EXE) $(OBJS) $(WEB_DIR)/*.js $(WEB_DIR)/*.wasm $(WEB_DIR)/*.wasm.pre
	rm -rf $(BUILD_DIR)
