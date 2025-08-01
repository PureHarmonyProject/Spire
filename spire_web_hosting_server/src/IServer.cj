package spire_web_hosting_server

import spire_web_http.*

public interface IServer {
    prop features: IFeatureCollection
    func start<TContext>(application: IHttpApplication<TContext>): Unit
    func stop(): Unit
}
