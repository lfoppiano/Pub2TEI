package org.pub2tei.service;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import org.apache.commons.lang3.StringUtils;
import org.pub2tei.document.DocumentProcessor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.NoSuchElementException;

/**
 * 
 * @author Patrice
 * 
 */
@Singleton
public class ProcessString {

    /**
     * The class Logger.
     */
    private static final Logger LOGGER = LoggerFactory.getLogger(ProcessString.class);

    @Inject
    public ProcessString() {
    }

    /**
     * 
     * @param text the raw string to process
     * @return a response object containing the structured xml representation 
     */
    public static Response processText(String text,
                                       final boolean segmentSentences,
                                       final boolean refine,
                                       final int consolidateReferences,
                                       ServiceConfiguration serviceConfiguration,
                                       Boolean generateIDs) {
        LOGGER.debug(methodLogIn());
        Response response = null;

        if (text == null || text.length() == 0) {
            LOGGER.warn("Empty text input");
            response = Response.status(Response.Status.BAD_REQUEST).build();
            LOGGER.debug(methodLogOut());
            return response;
        }

        try {
            LOGGER.debug(">> set raw text for stateless service'...");
            
            DocumentProcessor documentProcessor = new DocumentProcessor(serviceConfiguration);
            InputStream inputStream = new ByteArrayInputStream(text.getBytes());
            String retValString = documentProcessor.processXML(inputStream, segmentSentences, refine, consolidateReferences, generateIDs);

            if (!isResultOK(retValString)) {
                response = Response.status(Response.Status.NO_CONTENT).build();
            } else {
                response = Response.status(Response.Status.OK).entity(retValString).type(MediaType.TEXT_PLAIN).build();
            }
        } catch (NoSuchElementException nseExp) {
            LOGGER.error("Could not get an instance of converter. Sending service unavailable.");
            response = Response.status(Response.Status.SERVICE_UNAVAILABLE).build();
        } catch (Exception e) {
            LOGGER.error("An unexpected exception occurs. ", e);
            response = Response.status(Response.Status.INTERNAL_SERVER_ERROR).build();
        } 
        LOGGER.debug(methodLogOut());
        return response;
    }

    /**
     * Returns a string containing true, if the service is alive.
     *
     * @return a response object containing the string true if service
     * is alive.
     */
    public static String isAlive() {
        LOGGER.debug("called isAlive()...");

        String retVal = null;
        try {
            retVal = Boolean.valueOf(true).toString();
        } catch (Exception e) {
            LOGGER.error("Pub2TEI service is not alive, because of: ", e);
            retVal = Boolean.valueOf(false).toString();
        }
        return retVal;
    }

    /**
     * @return
     */
    public static String methodLogIn() {
        return ">> " + ProcessString.class.getName() + "." + Thread.currentThread().getStackTrace()[1].getMethodName();
    }

    /**
     * @return
     */
    public static String methodLogOut() {
        return "<< " + ProcessString.class.getName() + "." + Thread.currentThread().getStackTrace()[1].getMethodName();
    }

    /**
     * Check whether the result is null or empty.
     */
    public static boolean isResultOK(String result) {
        return StringUtils.isBlank(result) ? false : true;
    }

}
