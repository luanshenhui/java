import React from 'react';
import { connect } from 'react-redux';
import PropTypes from 'prop-types';
import qs from 'qs';
import CommentListHeaderForm from './CommentListHeaderForm';
import CommentListBody from './CommentListBody';
import GuideBase from '../../../components/common/GuideBase';
import InterviewHeader from '../../../containers/common/InterviewHeaderForm';
import SectionBar from '../../../components/SectionBar';
import { closeCommentListFlameGuide, loadCommentListFlameGuideRequest, openCommentDetailGuide } from '../../../modules/preference/pubNoteModule';

const CommentHead = ({ hainsUserData }) => {
  let res = null;
  if (hainsUserData && hainsUserData !== null && hainsUserData.authnote !== 1 && hainsUserData.authnote !== 2 && hainsUserData.authnote !== 3) {
    res = <div>参照登録権限がありません</div>;
  }
  return res;
};
const CommentBody = ({ params, pubNoteData1, pubNoteData2, pubNoteData3, pubNoteData4, pubNoteData5, pubNoteData6, onOpenCommentDetailGuide }) => {
  const res = [];
  res.push(<CommentListHeaderForm key={10} onOpenCommentDetailGuide={onOpenCommentDetailGuide} />);
  if (params.dispmode === '0') {
    res.push(<CommentListBody type="1" pubNoteData={pubNoteData1} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}1`} />);
    res.push(<CommentListBody type="2" pubNoteData={pubNoteData2} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}2`} />);
    res.push(<CommentListBody type="3" pubNoteData={pubNoteData3} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}3`} />);
  } else if (params.dispmode === '1') {
    res.push(<CommentListBody type="4" pubNoteData={pubNoteData4} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}4`} />);
    res.push(<CommentListBody type="5" pubNoteData={pubNoteData5} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}5`} />);
    res.push(<CommentListBody type="6" pubNoteData={pubNoteData6} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}6`} />);
  } else if (params.dispmode === '2') {
    res.push(<CommentListBody type="4" pubNoteData={pubNoteData4} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}7`} />);
  } else if (params.dispmode === '3') {
    res.push(<CommentListBody type="1" pubNoteData={pubNoteData1} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}8`} />);
  } else if (params.dispmode === '4') {
    res.push(<CommentListBody type="5" pubNoteData={pubNoteData5} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}9`} />);
  } else if (params.dispmode === '5') {
    res.push(<CommentListBody type="6" pubNoteData={pubNoteData6} params={params} onOpenCommentDetailGuide={onOpenCommentDetailGuide} key={`${params.dispmode}0`} />);
  }
  return res;
};

class CommentListFlameGuide extends React.Component {
  componentDidMount() {
    const { onLoad, match, location } = this.props;
    if (match) {
      const { params } = match;
      // qsを利用してquerystringをオブジェクト型に変換
      if (params.winmode === '0') {
        const qsparams = qs.parse(location.search, { ignoreQueryPrefix: true });
        onLoad({ ...qsparams, ...params });
      }
    }
  }

  // propが更新される際に呼ばれる処理
  componentWillReceiveProps(nextProps) {
    const { visible, onLoad, act, match, location } = this.props;
    const { params } = nextProps;
    if (!visible && nextProps.visible !== visible) {
      // ポップアップの場合
      if (match) {
        const { orgcd1, orgcd2, dispmode, cmtmode, perid, rsvno, ctrptcd, startdate, enddate, pubnotedivcd, dispkbn } = match.params;
        params.rsvno = rsvno;
        params.pubnotedivcd = pubnotedivcd;
        params.orgcd1 = orgcd1;
        params.orgcd2 = orgcd2;
        params.dispmode = dispmode;
        params.perid = perid;
        params.dispkbn = dispkbn;
        params.cmtmode = cmtmode;
        params.startdate = startdate;
        params.enddate = enddate;
        params.ctrptcd = ctrptcd;
      }
      params.act = act;
      // onLoadアクションの引数として渡す
      onLoad(params);
    }
    if (match) {
      // 面接支援から遷移の場合
      if (match.params.winmode === '0') {
        const { pathname } = location;
        if (pathname !== undefined) {
          if (location.pathname !== nextProps.location.pathname) {
            // qsを利用してquerystringをオブジェクト型に変換
            if (nextProps.match.params.winmode === '0') {
              const qsparams = qs.parse(nextProps.location.search, { ignoreQueryPrefix: true });
              onLoad({ ...qsparams, ...nextProps.match.params });
            }
          }
        }
      }
    }
  }

  // 描画処理
  render() {
    const { match, hainsUserData, params, pubNoteData1, pubNoteData2, pubNoteData3, pubNoteData4, pubNoteData5, pubNoteData6, onOpenCommentDetailGuide } = this.props;
    const getWinmode = () => {
      let res = {};
      if (match === undefined || match === null) {
        res = { winmode: null, rsvno: 0 };
      } else {
        const { winmode, rsvno, dispmode } = match.params;
        res = { winmode, rsvno, dispmode };
      }
      return res;
    };

    return (
      <div>
        {getWinmode().winmode === '0' && (
          <div>
            <SectionBar title="コメント情報" />
            <div>
              <CommentHead hainsUserData={hainsUserData} />
            </div>
            <div>
              <CommentBody
                params={params}
                pubNoteData1={pubNoteData1}
                pubNoteData2={pubNoteData2}
                pubNoteData3={pubNoteData3}
                pubNoteData4={pubNoteData4}
                pubNoteData5={pubNoteData5}
                onOpenCommentDetailGuide={onOpenCommentDetailGuide}
              />
            </div>
          </div>
        )}
        {(getWinmode().winmode === '1' || getWinmode().winmode === null) && (
          <GuideBase {...this.props} title="情報コメント" usePagination={false} >
            {getWinmode().winmode === '1' && (
              <div>
                {getWinmode().dispmode === '2' && (
                  <InterviewHeader rsvno={getWinmode().rsvno} reqwin={0} />
                )}
                <SectionBar title="コメント情報" />
              </div>
            )}
            <div>
              <CommentHead hainsUserData={hainsUserData} />
            </div>
            <div>
              <CommentBody
                params={params}
                pubNoteData1={pubNoteData1}
                pubNoteData2={pubNoteData2}
                pubNoteData3={pubNoteData3}
                pubNoteData4={pubNoteData4}
                pubNoteData5={pubNoteData5}
                pubNoteData6={pubNoteData6}
                onOpenCommentDetailGuide={onOpenCommentDetailGuide}
              />
            </div>
          </GuideBase>
        )}
      </div>
    );
  }
}

// propTypesの定義
CommentListFlameGuide.propTypes = {
  pubNoteData1: PropTypes.PropTypes.shape(),
  pubNoteData2: PropTypes.PropTypes.shape(),
  pubNoteData3: PropTypes.PropTypes.shape(),
  pubNoteData4: PropTypes.PropTypes.shape(),
  pubNoteData5: PropTypes.PropTypes.shape(),
  pubNoteData6: PropTypes.PropTypes.shape(),
  hainsUserData: PropTypes.PropTypes.shape(),
  params: PropTypes.shape(),
  onLoad: PropTypes.func.isRequired,
  ctrptcd: PropTypes.string,
  orgcd1: PropTypes.string,
  orgcd2: PropTypes.string,
  dispmode: PropTypes.string,
  cmtmode: PropTypes.string,
  perid: PropTypes.string,
  rsvno: PropTypes.number,
  userid: PropTypes.string,
  startdate: PropTypes.string,
  enddate: PropTypes.string,
  act: PropTypes.string,
  visible: PropTypes.bool,
  match: PropTypes.shape(),
  onOpenCommentDetailGuide: PropTypes.func,
  location: PropTypes.shape(),
};

CommentListFlameGuide.defaultProps = {
  onOpenCommentDetailGuide: null,
  pubNoteData1: null,
  pubNoteData2: null,
  pubNoteData3: null,
  pubNoteData4: null,
  pubNoteData5: null,
  pubNoteData6: null,
  hainsUserData: null,
  params: null,
  ctrptcd: null,
  orgcd1: null,
  orgcd2: null,
  dispmode: null,
  cmtmode: null,
  perid: null,
  rsvno: null,
  userid: null,
  startdate: null,
  enddate: null,
  act: null,
  visible: false,
  match: undefined,
  location: undefined,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  // 可視状態
  visible: state.app.preference.pubNote.commentListFlameGuide.visible,
  params: state.app.preference.pubNote.commentListFlameGuide.params,
  pubNoteData1: state.app.preference.pubNote.commentListFlameGuide.pubNoteData1,
  pubNoteData2: state.app.preference.pubNote.commentListFlameGuide.pubNoteData2,
  pubNoteData3: state.app.preference.pubNote.commentListFlameGuide.pubNoteData3,
  pubNoteData4: state.app.preference.pubNote.commentListFlameGuide.pubNoteData4,
  pubNoteData5: state.app.preference.pubNote.commentListFlameGuide.pubNoteData5,
  pubNoteData6: state.app.preference.pubNote.commentListFlameGuide.pubNoteData6,
  hainsUserData: state.app.preference.pubNote.commentListFlameGuide.hainsUserData,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onLoad: (params) => {
    // 画面を初期化
    dispatch(loadCommentListFlameGuideRequest({ params }));
  },
  onOpenCommentDetailGuide: ({ params, values }) => {
    // 開くアクションを呼び出す
    let pubnotedivcd = '';
    let rsvno = '0';
    if (values) {
      ({ pubnotedivcd, rsvno } = values);
    }
    const { selinfo, seq } = params;
    let updatecmtmode = null;
    if (seq && seq > 0) {
      switch (selinfo) {
        case 1:
          updatecmtmode = '1,0,0,0';
          break;
        case 2:
          updatecmtmode = '0,1,0,0';
          break;
        case 3:
          updatecmtmode = '0,0,1,0';
          break;
        case 4:
          updatecmtmode = '0,0,0,1';
          break;
        default:
          break;
      }
    } else {
      updatecmtmode = params.cmtmode;
    }
    let conditions = { ...params, cmtmode: updatecmtmode, pubnotedivcd };
    if (rsvno && rsvno !== null) {
      conditions = { ...params, rsvno, cmtmode: updatecmtmode, pubnotedivcd };
    }
    dispatch(openCommentDetailGuide({ conditions }));
  },
  // クローズ時の処理
  onClose: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeCommentListFlameGuide());
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(CommentListFlameGuide);
