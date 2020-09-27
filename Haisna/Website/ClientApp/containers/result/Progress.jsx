import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import qs from 'qs';
import styled from 'styled-components';
import moment from 'moment';

import PageLayout from '../../layouts/PageLayout';
import ProgressHeaderForm from './ProgressHeaderForm';
import ProgressBody from './ProgressBody';
import Pagination from '../../components/Pagination';
import CircularProgress from '../../components/control/CircularProgress/CircularProgress';

import { getProgressNameRequest, rslMainShowRequest, initializeProgressList, loadingRequest } from '../../modules/result/resultModule';

const Pair = styled.span`
  font-weight: bold;
  color: red;
`;
const WaringMessage = styled.p`
  color: red;
`;

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const CslDate = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class Progress extends React.Component {
  componentDidMount() {
    this.props.getProgressName();
  }
  componentWillUnmount() {
    const { initialState } = this.props;
    initialState();
  }

  render() {
    const { conditions, totalcount, history, match, onsearch, strMessage, isLoading, message1, message2, lngErrLog1, fileName1, errDate } = this.props;
    return (
      <PageLayout title="受診進捗状況">
        {strMessage !== '' &&
          <WaringMessage>{strMessage}</WaringMessage>
        }
        <ProgressHeaderForm {...this.props} />
        {onsearch &&
          <div>
            {!conditions.rsvNo &&
              <div>
                <div>「<CslDate>{moment(conditions.cslDate).format('YYYY年M月D日')}</CslDate>」の受診者一覧を表示しています。</div>
                <div>受診者数は <TotalCount>{totalcount}</TotalCount>人です。</div>
              </div>
            }
            {message1 &&
              <WaringMessage>message1</WaringMessage>
            }
            {lngErrLog1 === 1 && fileName1 !== '' &&
              <div>
                <WaringMessage><b>エラーが発生しています！(横河連携) システム担当へ連絡して下さい。</b></WaringMessage>
                <p>最終更新日時：{errDate}</p>
              </div>
            }
            {message2 &&
              <WaringMessage>message2</WaringMessage>
            }
            {totalcount > 0 &&
              <div>
                <div>○：検査完了&nbsp;&nbsp;●：一部未入力あり&nbsp;&nbsp;▲：未検査&nbsp;&nbsp;空白：依頼なし（受診進捗欄をクリックすると対象受診歴の結果入力画面にジャンプします）</div>
                <div><Pair>✔</Pair>:自動判定処理による判定結果登録あり（自動判定処理実施済み）</div>
                <ProgressBody {...this.props} />
              </div>
            }
          </div>
        }
        {totalcount > conditions.getCount && (
          <Pagination
            startPos={Number.parseInt(conditions.startPos, 10)}
            rowsPerPage={Number.parseInt(conditions.getCount, 10)}
            totalCount={totalcount}
            onSelect={(page) => {
              // ページ番号をクリックした場合はhistory.pushによるページ遷移を行わせる
              const startPos = ((page - 1) * conditions.getCount) + 1;
              // 結果的にcomponentWillReceivePropsメソッドが呼ばれることにより画面の再描画が行われる
              history.push({
                pathname: match.url,
                search: qs.stringify({ ...conditions, startPos }),
              });
            }}
          />
        )}
        {isLoading && <CircularProgress />}
      </PageLayout>
    );
  }
}

// propTypesの定義
Progress.propTypes = {
  conditions: PropTypes.shape().isRequired,
  totalcount: PropTypes.number,
  history: PropTypes.shape().isRequired,
  match: PropTypes.shape().isRequired,
  getProgressName: PropTypes.func.isRequired,
  onsearch: PropTypes.bool,
  strMessage: PropTypes.string,
  isLoading: PropTypes.bool,
  message1: PropTypes.string.isRequired,
  message2: PropTypes.string.isRequired,
  lngErrLog1: PropTypes.number.isRequired,
  fileName1: PropTypes.string.isRequired,
  errDate: PropTypes.string.isRequired,
  initialState: PropTypes.func.isRequired,
};

// defaultPropsの定義
Progress.defaultProps = {
  totalcount: null,
  onsearch: false,
  strMessage: '',
  isLoading: false,
};

const mapStateToProps = (state) => ({
  conditions: state.app.result.result.progressList.conditions,
  totalcount: state.app.result.result.progressList.totalcount,
  onsearch: state.app.result.result.progressList.onsearch,
  strMessage: state.app.result.result.progressList.strMessage,
  message1: state.app.result.result.progressList.message1,
  message2: state.app.result.result.progressList.message2,
  lngErrLog1: state.app.result.result.progressList.lngErrLog1,
  fileName1: state.app.result.result.progressList.fileName1,
  errDate: state.app.result.result.progressList.errDate,
  isLoading: state.app.result.result.progressList.isLoading,
});


const mapDispatchToProps = (dispatch) => ({
  getProgressName: () => {
    dispatch(getProgressNameRequest());
  },
  // 表示
  onSubmit: (params, redirect) => {
    dispatch(rslMainShowRequest({ params, redirect }));
  },
  initialState: () => {
    dispatch(initializeProgressList());
  },
  loading: () => {
    dispatch(loadingRequest());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(Progress));
