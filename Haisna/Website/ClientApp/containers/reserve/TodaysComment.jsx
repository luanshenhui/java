import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import Button from '../../components/control/Button';

import { getAllBbsRequest, deleteBbsRequest } from '../../modules/common/bbsModule';

const icondelete = (
  <svg width="18" height="18" viewBox="0 0 1024 1024" fill="red">
    <path d="M920.144 187.344l-147.424-147.536-668.816 668.912 147.568 147.472zM772.72 856.192l147.424-147.472-668.608-668.912-147.68 147.536z" />
  </svg>);

// 今日のコメント取得
class TodaysComment extends React.Component {
  constructor(props) {
    super(props);

    this.handleAddComentClick = this.handleAddComentClick.bind(this);
    this.handleDelComentClick = this.handleDelComentClick.bind(this);
  }

  componentDidMount() {
    // ロード時処理を呼び出す
    const { initAllBbs } = this.props;
    // 今日のコメント取得
    initAllBbs({ today: moment().format('YYYY/M/D') });
  }

  // addcomentボタンクリック時の処理
  handleAddComentClick() {
    const { history } = this.props;
    history.push('/reserve/frontdoor/entrycomment');
  }

  // addcomentボタンクリック時の処理
  handleDelComentClick(bbskey, delUserId, userId) {
    const { onDelete, initAllBbs } = this.props;
    if (delUserId !== userId) {
      // eslint-disable-next-line no-alert,no-restricted-globals
      alert('投稿者とユーザーIDが違います。');
    } else {
      // eslint-disable-next-line no-alert,no-restricted-globals
      const res = confirm('指定メッセージを削除します。よろしいですか？');
      if (res === true) {
        onDelete({ bbskey }, () => initAllBbs({ today: moment().format('YYYY/M/D') }));
      }
    }
  }

  // 今日のコメント表示
  render() {
    const { data } = this.props;

    return (
      <div>
        <div style={{ width: '97%', marginTop: '8px', padding: '0' }}>
          <div style={{ marginTop: '40px', fontSize: '16px', float: 'left' }}>
            今 日 の コ メ ン ト
          </div>
        </div>
        <div style={{ width: '97%', marginTop: '8px', padding: '0' }}>
          <div style={{ fontSize: '36px', float: 'right' }}>
            <span style={{ fontFamily: 'arial narrow', color: 'silver' }}>today&apos;s comment</span>
          </div>
        </div>
        <div style={{ clear: 'both' }} />
        <div style={{ width: '97%', height: '2px', backgroundColor: '#cccccc', padding: '0' }} />
        <div style={{ width: '97%', marginTop: '8px', padding: '0' }}>
          <div style={{ float: 'right' }}>
            <Button className="btn" onClick={this.handleAddComentClick} value="コメントを追加する" />
          </div>
        </div>
        <div style={{ clear: 'both' }} />

        <div style={{ overflow: 'auto', height: '400px' }}>
          {data && data.length > 0 && (
          data.map((rec) => (
            <div key={rec.bbskey}>
              <div style={{ color: '#cccccc', float: 'left', marginLeft: '10px', width: '20px' }}>■</div>
              <div style={{ color: '#777777', fontWeight: 'bolder', float: 'left', marginLeft: '0px' }}>{rec.title}</div>
              <div style={{ color: '#999999', float: 'left', marginLeft: '10px' }}>{rec.handle}</div>
              <div style={{ color: '#999999', float: 'left', marginLeft: '10px' }}>{moment(rec.upddate).format('YYYY/MM/DD')}</div>
              <div style={{ color: '#999999', float: 'left', marginLeft: '10px' }}>{`(${moment(rec.upddate).format('ddd')})`}</div>
              <div style={{ color: '#999999', float: 'left', marginLeft: '10px' }}>{moment(rec.upddate).format('HH:mm:ss')}</div>
              <div style={{ color: '#999999', float: 'left', marginLeft: '10px' }}>
                <a
                  role="presentation"
                  onClick={() => (this.handleDelComentClick(rec.bbskey, rec.upduser, rec.upduser))}
                  style={{ cursor: 'pointer' }}
                >
                  <span title="このコメントを削除します">{icondelete}</span>
                </a>
              </div>
              <div style={{ clear: 'both' }} />
              <div style={{ marginLeft: '30px' }}>
                {rec.message.split('\n').map((item, key) => (
                  <span key={`comment-${key.toString()}`}>
                    {item}
                    <br />
                  </span>
                  ))}
              </div>
            </div>
          ))
        )}

        </div>
      </div>
    );
  }
}

// propTypesの定義
TodaysComment.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onDelete: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  initAllBbs: PropTypes.func.isRequired,
};

const mapStateToProps = (state) => ({
  data: state.app.common.bbs.bbsList.data,
});

const mapDispatchToProps = (dispatch) => ({
  initAllBbs: (params) => {
    dispatch(getAllBbsRequest({ params }));
  },
  onDelete: (params, redirect) => dispatch(deleteBbsRequest({ params, redirect })),
});

export default connect(mapStateToProps, mapDispatchToProps)(TodaysComment);
