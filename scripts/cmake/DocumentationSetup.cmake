IF(DOXYGEN_EXECUTABLE)

	OPTION(DOCS_GENERATE_DIAGRAMS "Use the DOT tool to generate class diagrams." OFF)
	OPTION(DOCS_GENERATE_CALL_GRAPHS "Generate call dependency graphs." OFF)
	OPTION(DOCS_GENERATE_COLLABORATION_GRAPHS "Generate collaboration graphs." OFF)
	IF(APPLE)
		OPTION(DOCS_GENERATE_DOCSET "Generate Apple Docsets." OFF)
	ENDIF() # APPLE

	IF(NOT DOT_TOOL_PATH AND (DOCS_GENERATE_DIAGRAMS OR DOCS_GENERATE_CALL_GRAPHS OR
		DOCS_GENERATE_COLLABORATION_GRAPHS))
		MESSAGE(WARNING "The DOT tool was not found but is needed for generating doxygen diagrams!")
	ENDIF() # DOT_TOOL_PATH AND (DOCS_GENERATE_DIAGRAMS OR ...)

	IF(DOCS_GENERATE_CALL_GRAPHS)
		SET(DOCS_GENERATE_CALL_GRAPHS_STRING "YES" CACHE INTERNAL "")
	ENDIF() # DOCS_GENERATE_CALL_GRAPHS

	IF(DOCS_GENERATE_COLLABORATION_GRAPHS)
		SET(DOCS_GENERATE_COLLABORATION_GRAPHS_STRING "YES" CACHE INTERNAL "")
	ENDIF() # DOCS_GENERATE_COLLABORATION_GRAPHS

	# GET_FILENAME_COMPONENT(DOT_TOOL_PATH_ONLY ${DOT_TOOL_PATH} PATH)
	CONFIGURE_FILE(scripts/docs/Doxyfile.in ${PROJECT_BINARY_DIR}/Doxyfile)
	ADD_CUSTOM_TARGET(doc ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/Doxyfile
		WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
		COMMENT "Generating source code documentation with Doxygen." VERBATIM)

	SET(DOCS_GENERATE_TREEVIEW_STRING "YES" CACHE INTERNAL "")
	SET(DOCS_DISABLE_INDEX_STRING "NO" CACHE INTERNAL "")
	IF(DOCS_GENERATE_DOCSET)
		SET(DOCS_GENERATE_TREEVIEW_STRING "NO" CACHE INTERNAL "" FORCE)
		SET(DOCS_DISABLE_INDEX_STRING "YES" CACHE INTERNAL "" FORCE)
		SET(DOCS_GENERATE_DOCSET_STRING "YES" CACHE INTERNAL "")
		ADD_CUSTOM_COMMAND(TARGET doc POST_BUILD
			COMMAND make WORKING_DIRECTORY ${PROJECT_BINARY_DIR}/docs
			COMMENT "Generating docset ...")
	ENDIF() # DOCS_GENERATE_DOCSET


ENDIF() # DOXYGEN_EXECUTABLE