package spire_web_hosting_server

import spire_web_http.*

public interface IHttpApplication<TContext> {
    func createContext(contextFeatures: IFeatureCollection): TContext
    func processRequest(context: TContext): Unit
    func closeContext(context: TContext, exception: Exception): Unit
}
