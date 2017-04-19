#ifndef QT_BOOKMARK_H
#define QT_BOOKMARK_H

#include <QFrame>
#include <QLabel>
#include <QPushButton>

#include "utility/messaging/MessageListener.h"
#include "utility/messaging/type/MessageDeleteBookmark.h"
#include "utility/messaging/type/MessageEditBookmark.h"

#include "data/bookmark/Bookmark.h"

#include <QTreeWidget>

class QtBookmark
	: public QFrame
	, public MessageListener<MessageEditBookmark>
{
	Q_OBJECT

public:
	QtBookmark();
	virtual ~QtBookmark();

	void setBookmark(const std::shared_ptr<Bookmark> bookmark);
	Id getBookmarkId() const;

	QTreeWidgetItem* getTreeWidgetItem() const;
	void setTreeWidgetItem(QTreeWidgetItem* treeWidgetItem);

public slots:
	void commentToggled();

protected:
	virtual void resizeEvent(QResizeEvent* event) Q_DECL_OVERRIDE;
	virtual void showEvent(QShowEvent* event) Q_DECL_OVERRIDE;

	virtual void enterEvent(QEvent *event) Q_DECL_OVERRIDE;
	virtual void leaveEvent(QEvent *event) Q_DECL_OVERRIDE;

private slots:
	void activateClicked();
	void editClicked();
	void deleteClicked();
	void elideButtonText();

private:
	void handleMessage(MessageEditBookmark* message) override;

	void updateArrow();

	std::string getDateString() const;

	QPushButton* m_activateButton;
	QPushButton* m_editButton;
	QPushButton* m_deleteButton;
	QPushButton* m_toggleCommentButton;

	QLabel* m_comment;
	QLabel* m_dateLabel;

	std::shared_ptr<Bookmark> m_bookmark;

	// pointer to the bookmark category item in the treeView, allows to refresh tree view when a node changes in size
	// (e.g. toggle comment). Not a nice solution to the problem, but couldn't find anything better yet.
	// (sizeHintChanged signal can't be emitted here...)
	QTreeWidgetItem* m_treeWidgetItem;

	std::string m_arrowImageName;
	bool m_hovered;

	bool m_ignoreNextResize;
};

#endif // QT_BOOKMARK_H