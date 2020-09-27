import React from 'react';
import PropTypes from 'prop-types';
import moment from 'moment';
import { withRouter, Link } from 'react-router-dom';
import { connect } from 'react-redux';
import Label from '../../../components/control/Label';
import Table from '../../../components/Table';
import MessageBanner from '../../../components/MessageBanner';
import LabelCourseWebColor from '../../../components/control/label/LabelCourseWebColor';
import { registerCopyRequest, registerReleaseRequest } from '../../../modules/preference/contractModule';


const LinkToDetail = ({ match, rec }) => {
  let res;
  if (rec.reforgcd1 === match.params.orgcd1 && rec.reforgcd2 === match.params.orgcd2) {
    res = <Link to={`/contents/preference/contract/organization/${match.params.orgcd1}/${match.params.orgcd2}/detail/${rec.cscd}/${rec.ctrptcd}/`}>詳細</Link >;
  } else {
    res = <span />;
  }
  return res;
};
const LinkToCopyRelease = ({ match, rec, copyEvent, releaseEvent }) => {
  const res = [];
  if (rec.reforgcd1 === match.params.orgcd1 && rec.reforgcd2 === match.params.orgcd2) {
    res.push(<span key={`${rec.reforgcd1}-${rec.reforgcd2}`} />);
  } else {
    res.push(<Link to={`/contents/preference/contract/organization/${rec.reforgcd1}/${rec.reforgcd2}/detail/${rec.cscd}/${rec.ctrptcd}`}>{rec.orgname}</Link>);
    res.push(<span>&nbsp;→&nbsp;</span>);
    res.push(<Label><a role="presentation" style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }} onClick={copyEvent}>コピー</a></Label>);
    res.push(<Label><a role="presentation" style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }} onClick={releaseEvent}>参照解除</a></Label>);
  }
  return res;
};

class CtrCourseListBody extends React.Component {
  constructor(props) {
    super(props);
    const { match } = this.props;
    this.orgcd1 = match.params.orgcd1;
    this.orgcd2 = match.params.orgcd2;
    this.cscd = match.params.cscd;
    this.strDate = match.params.strDate;
    this.endDate = match.params.endDate;
    this.handleCopyClick = this.handleCopyClick.bind(this);
    this.handleReleaseClick = this.handleReleaseClick.bind(this);
  }

  // コピー
  handleCopyClick(data) {
    const { onSubmitClick, match } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この契約情報をコピーします。よろしいですか？')) {
      return;
    }
    onSubmitClick(match.params, data);
  }

  // 参照解除
  handleReleaseClick(data) {
    const { onRefClick, match } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この契約情報の参照を解除します。よろしいですか？')) {
      return;
    }
    onRefClick(match.params, data);
  }
  render() {
    const { data, message, match } = this.props;
    return (
      <div>
        <MessageBanner messages={message} />
        {data && data.length > 0 && (
          <Table>
            <thead>
              <tr>
                <th>受診コース</th>
                <th >契約期間</th>
                <th>年齢起算日</th>
                <th>操作</th>
                <th>参照中の契約情報</th>
              </tr>
            </thead>
            <tbody>
              {data && data.map((rec, index) => (
                <tr key={index.toString()}>
                  <td><LabelCourseWebColor webcolor={rec.webcolor}>■</LabelCourseWebColor>{rec.csname}</td>
                  <td>{moment(rec.strdate).format('YYYY年M月D日')}～{moment(rec.enddate).format('YYYY年M月D日')}
                  </td>
                  {rec.agecalc && rec.agecalc.length === 8 && (
                    <td >{`${rec.agecalc}`.substr(0, 4)}年{Number.parseInt(`${rec.agecalc}`.substr(4, 2), 10)}月{Number.parseInt(`${rec.agecalc}`.substr(6, 2), 10)}日</td>
                  )}
                  {rec.agecalc != null && `${rec.agecalc}`.length === 4 && (
                    <td >{Number.parseInt(`${rec.agecalc}`.substr(0, 2), 10)}月{Number.parseInt(`${rec.agecalc}`.substr(2, 2), 10)}日</td>
                  )}
                  {rec.agecalc === null && (
                    <td />
                  )}
                  <td><LinkToDetail match={match} rec={rec} /></td>
                  <td><LinkToCopyRelease match={match} rec={rec} copyEvent={() => this.handleCopyClick(rec)} releaseEvent={() => this.handleReleaseClick(rec)} /></td>
                </tr>
              ))}
            </tbody>
          </Table>
        )}
      </div>
    );
  }
}
// propTypesの定義
CtrCourseListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  match: PropTypes.shape().isRequired,
  onSubmitClick: PropTypes.func.isRequired,
  onRefClick: PropTypes.func.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.contract.contractList.data,
  message: state.app.preference.contract.contractList.message,
});
const mapDispatchToProps = (dispatch) => ({

  onSubmitClick: (params, data) => {
    dispatch(registerCopyRequest({ data: { ...data, orgcd1: params.orgcd1, orgcd2: params.orgcd2 } }));
  },

  onRefClick: (params, data) => {
    dispatch(registerReleaseRequest({ data: { ...data, orgcd1: params.orgcd1, orgcd2: params.orgcd2 } }));
  },

});
export default withRouter(connect(mapStateToProps, mapDispatchToProps)(CtrCourseListBody));
