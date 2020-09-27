import qs from 'qs';
import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import PageLayout from '../../../layouts/PageLayout';
import Button from '../../../components/control/Button';
import MessageBanner from '../../../components/MessageBanner';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import DropDownRsvGrp from '../../../components/control/dropdown/DropDownRsvGrp';
import DropDownCourseRsvGrp from '../../../components/control/dropdown/DropDownCourseRsvGrp';
import { checkRsvFraCopyInput, initializeRsvFraCopy } from '../../../modules/preference/scheduleModule';

const formName = 'RsvFraCopy1';

class RsvFraCopy1 extends React.Component {
  constructor(props) {
    super(props);
    this.handleNextClick = this.handleNextClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, location } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const qsparams = qs.parse(location.search, { ignoreQueryPrefix: true });
    onLoad(qsparams);
  }

  // 次へボタンをクリックする処理
  handleNextClick(values) {
    const { history, onSubmit } = this.props;
    onSubmit(
      values,
      () => history.push({
        pathname: '/contents/preference/schedule/rsvfracopy2',
        search: qs.stringify({ ...values }),
      }),
    );
  }

  render() {
    const { message, handleSubmit } = this.props;
    return (
      <PageLayout title="予約枠コピー">
        <form onSubmit={handleSubmit((values) => this.handleNextClick(values))}>
          <MessageBanner messages={message} />
          <FieldGroup itemWidth={200}>
            <FieldSet>
              <FieldItem><div style={{ textAlign: 'left' }}><span style={{ color: '#ff0000' }}>■&nbsp;</span>コピー元受診日</div></FieldItem>
              <Field name="startcsldate" component={DatePicker} id="startdate" />
            </FieldSet>
            <FieldSet>
              <FieldItem><div style={{ textAlign: 'left' }}><span style={{ color: '#000000' }}>□&nbsp;</span>コースコード</div></FieldItem>
              <Field name="cscd" component={DropDownCourseRsvGrp} addblank id="cscd" />
            </FieldSet>
            <FieldSet>
              <FieldItem><div style={{ textAlign: 'left' }}><span style={{ color: '#000000' }}>□&nbsp;</span>予約群</div></FieldItem>
              <Field name="rsvgrpcd" component={DropDownRsvGrp} addblank id="rsvgrpcd" />
            </FieldSet>
            <FieldSet>
              <Button onClick={handleSubmit((values) => this.handleNextClick(values))} value="次　へ" />
            </FieldSet>
          </FieldGroup>
        </form>
      </PageLayout>
    );
  }
}

// propTypesの定義
RsvFraCopy1.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  handleSubmit: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  onLoad: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  location: PropTypes.shape(),
};

RsvFraCopy1.defaultProps = {
  location: undefined,
};

const RsvFraCopyForm1 = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RsvFraCopy1);


const mapStateToProps = (state) => ({
  initialValues: state.app.preference.schedule.rsvFraCopy1.conditions,
  message: state.app.preference.schedule.rsvFraCopy1.message,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSubmit: (conditions, rsvFraCopyNextPage) => {
    const { startcsldate } = conditions;
    const wsdate = (startcsldate === '' ? moment(new Date()).format('YYYY/MM/DD') : startcsldate);
    dispatch(checkRsvFraCopyInput({ ...conditions, endcsldate: wsdate, rsvFraCopyNextPage }));
  },
  onLoad: (param) => {
    const { backFlag } = param;
    dispatch(initializeRsvFraCopy({ backFlag: backFlag === undefined ? 0 : backFlag }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RsvFraCopyForm1));
