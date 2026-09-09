package de.gbv.profkat.bpmn.workflows.create_object_simple;

import java.util.Objects;

import org.mycore.profkat.bpmn.workflows.create_object_simple.MCRWorkflowMgrPerson;

/**
 * Workflow manager for CUG-specific object creation.
 *
 * <p>Provides default metadata for CUG object types that require
 * custom initialization. Currently, this only applies to
 * {@code cug_matrikel} objects.
 */
public class CUGWorkflowMgr extends MCRWorkflowMgrPerson {

    private static final String CUG_MATRIKEL = "cug_matrikel";

    @Override
    protected String getDefaultMetadataXML(String base) {
        if (Objects.equals(CUG_MATRIKEL, base)) {
            return getDefaultMatrikelXML();
        }
        return super.getDefaultMetadataXML(base);
    }

    private String getDefaultMatrikelXML() {
        return """
            <metadata>
                <box.name class='MCRMetaPersonName'>
                    <name>
                        <surname inherited='0' form='plain'>Neuer Matrikel</surname>
                    </name>
                </box.name>
            </metadata>
            """;
    }

}
