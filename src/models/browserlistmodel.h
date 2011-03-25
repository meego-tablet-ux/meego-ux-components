
/**
 * Filename:
 *     browserlistmodel.h
 *
 * Description:
 *     Provide data model for web panel, including recently visited pages,
 *     bookmarks. 
 *
 *     Note that this model requires an extension named chrome-meego-extension
 *     has been installed into chromium browser. The responsibility of this
 *     extension is to save browsing information at browser's runtime.
 *
 * Usage:
 *     Reference browsermodeltest.qml about how to use it
 *
 * Author:
 *     Hongbo Min, hongbo.min@intel.com
 *
 * Date:
 *     Oct 13, 2010
 */

#ifndef BROWSER_LIST_MODEL_H_
#define BROWSER_LIST_MODEL_H_

#include <QAbstractListModel>
#include <QSqlDatabase>
#include <QList>
#include <QDBusConnection>
#include <QDBusPendingReply>
#include <QDBusReply>
#include <QDBusInterface>
#include <QDBusConnectionInterface>

#include "browserserviceiface.h"

class BrowserItem : public QObject
{
	Q_OBJECT
	Q_PROPERTY(int id READ id);
	Q_PROPERTY(QString url READ url);
	Q_PROPERTY(QString title READ title);
	Q_PROPERTY(QString faviconUri READ faviconUri);
	Q_PROPERTY(QString thumbnailUri READ thumbnailUri);

	friend class BrowserItemListModel;

public:	
	explicit BrowserItem(QObject* parent = 0) : QObject(parent) {}
	explicit BrowserItem(int id, const QString& url, const QString& title, 
			const QString& faviconUrl, QObject* parent = 0);

	enum Role
	{
		IdRole  = Qt::UserRole + 1,
		UrlRole = Qt::UserRole + 2,
		TitleRole = Qt::UserRole + 3,
		IconUriRole = Qt::UserRole + 4,
		ThumbnailUriRole = Qt::UserRole + 5
    };

	int       id() const  { return m_id; }
	QString   url() const { return m_url; }
	QString   title() const { return m_title; }
	QString   faviconUri() const { return m_faviconUri; }
	QString   thumbnailUri() const { return m_thumbnailUri; }

protected:
	int        m_id;          // Unique identifier
	QString    m_url;         // URL
	QString    m_title;       // title  
	QString    m_faviconUri;  // URI for favicon
	QString    m_thumbnailUri;// URI for thumbnail
};

class BrowserItemListModel : public QAbstractListModel
{
	Q_OBJECT
	Q_ENUMS(ModelType);
	Q_ENUMS(SortType);
    Q_PROPERTY(ModelType type READ type WRITE setType);
    Q_PROPERTY(SortType sortType READ sortType WRITE setSortType);
	Q_PROPERTY(int limit READ limit WRITE setLimit); 
	
public:
	enum ModelType { 
		ListofRecentVisited = 0,   // History page
		ListofBookmarks = 1,  	   // Bookmark
		ListofTabs = 2        	   // Tab page being opened
	};

	enum SortType
	{
		SortByDefault = 0,    // Visited time as default sort type
		SortByVisitedCount = 1,
	};
	
    BrowserItemListModel(ModelType type = ListofRecentVisited, QObject* parent = 0);
	~BrowserItemListModel();
	
	ModelType type() const { return m_type; } 
	SortType sortType() const { return m_sorttype; }
	int limit() const { return m_limit; }
		
	void setType(ModelType type);
	void setSortType(SortType type);
	void setLimit(int max);
	
	QVariant data(const QModelIndex& index, int role) const;
	int rowCount(const QModelIndex& parent = QModelIndex()) const;
	
public Q_SLOTS:
	// View the given url in external browser
	void viewItem(const QString& url);   
	// Delete the given item from the list
	void destroyItem(int id);
	// Remove all items from both this data model and
	// backend database
	void clearAllItems();

Q_SIGNALS:
	void typeChanged(int type);
	void sortTypeChanged(int sort);
	void limitChanged(int limit);
	void browserLaunched();
	void browserExited();
	
private Q_SLOTS:
    void bookmarkRemoved(uint id);
    void bookmarkUpdated(uint id, const QString &url, const QString &title, const QString &faviconUrl);
    void faviconUpdated(const QString &url);
    void thumbnailUpdated(const QString &url);
    void urlRemoved(const QString &url);
    void urlVisited(uint id, const QString &url, const QString &title, const QString &faviconUrl);
		void dbusServiceChanged(const QString& name, const QString& old_ower, const QString& new_owner);
		
	void onBrowserLaunched();
	void onBrowserExited();

private:
    bool loadDataSource();
	BrowserItem* getItem(int id);
	BrowserItem* getItem(const QString& url);
	bool internalRemoveItem(int id);
	bool isBrowserRunning() const;
	void destroyItemsByBrowser();
	void viewItemsByBrowser();

	void clearData();
		
	ModelType    		 	    m_type;
	SortType         			m_sorttype;
	QList<BrowserItem*> 	   	m_items;   
	int              			m_limit;
	BrowserServiceInterface*    m_iface;   // DBus interface for communicating with chrome plugin
	bool                        m_browserIsLaunching;
	
	QStringList                 m_bookmarksToBeDeleted;
	QStringList                 m_vistedpageToBeDeleted;
	QStringList 	            m_urlToBeViewed;
	QSqlDatabase    			m_db; 
};
#endif
