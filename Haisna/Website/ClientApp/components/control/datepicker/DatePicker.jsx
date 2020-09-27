import React from 'react';
import PropTypes from 'prop-types';

import classNames from 'classnames';
import moment from 'moment';
import Draggable from 'react-draggable';

import DayViews from './DayViews';
import MonthView from './MonthView';
import YearView from './YearView';
import Util from './Util';
import getIcon from './Icon';

// cssのインポート
import styles from './DatePicker.css';

class DatePicker extends React.Component {
  constructor(props, context) {
    super(props, context);

    // 日付を日本語に指定
    moment.locale('ja');

    const defaultDate = props.required ? moment() : null; // 初期値
    const inputDate = props.input ? props.input.value : props.value;
    const date = inputDate ? moment(Util.toDate(inputDate)) : defaultDate; // 入力日付
    const minDate = props.minDate ? moment(Util.toDate(props.minDate)) : null; // 最小日付
    const maxDate = props.maxDate ? moment(Util.toDate(props.maxDate)) : null; // 最大日付
    const format = props.format || 'YYYY/MM/DD'; // 画面に表示する日付の書式
    const minView = 0; // 入力する日付の最小単位(0:日 1:月 2:年)
    const computableFormat = 'YYYY/MM/DD'; // onChangeで帰ってくる日付のフォーマット
    const closeOnSelect = props.closeOnSelect || true; // カレンダーで日付を指定したらカレンダーを閉じる

    this.state = {
      date,
      defaultDate,
      minDate,
      maxDate,
      format,
      computableFormat,
      inputValue: date ? date.format(format) : undefined, // テキストボックスにセットする値
      minView,
      currentView: minView || 0, // 現在のカレンダー入力単位
      isVisible: false, // カレンダーの表示状態
      closeOnSelect,
      prevdate: defaultDate, // 変更前の日付
    };

    this.setDate = this.setDate.bind(this);
    this.documentClick = this.documentClick.bind(this);
    this.closeClick = this.closeClick.bind(this);
    this.focusDateInput = this.focusDateInput.bind(this);
    this.inputBlur = this.inputBlur.bind(this);
    this.inputFocus = this.inputFocus.bind(this);
    this.keyDown = this.keyDown.bind(this);
    this.nextView = this.nextView.bind(this);
    this.prevView = this.prevView.bind(this);
    this.todayClick = this.todayClick.bind(this);
    this.toggleClick = this.toggleClick.bind(this);
    this.calendarClick = this.calendarClick.bind(this);
    this.changeDate = this.changeDate.bind(this);
  }

  // コンポーネントのマウントが完了した時の処理
  componentDidMount() {
    // ドキュメントにクリックイベントを追加する
    document.addEventListener('click', this.documentClick);

    // フォーカス指定がある場合テキストボックスにフォーカスする
    if (this.props.focused) {
      this.focusDateInput();
    }
  }

  componentWillReceiveProps(nextProps) {
    const value = nextProps.input ? nextProps.input.value : nextProps.value;
    const newState = {
      date: value ? moment(Util.toDate(value)) : this.state.date,
      inputValue: value
        ? moment(Util.toDate(value)).format(this.state.format)
        : null,
      minDate: nextProps.minDate ? moment(Util.toDate(nextProps.minDate)) : null,
      maxDate: nextProps.maxDate ? moment(Util.toDate(nextProps.maxDate)) : null,
    };

    if (nextProps.disabled === true) {
      newState.isVisible = false;
    }

    this.setState(newState);
  }

  // コンポーネントがアップデートされるときの処理
  componentDidUpdate(prevProps) {
    if (this.props.focused !== prevProps.focused && this.props.focused) {
      this.focusDateInput();
    }
  }

  componentWillUnmount() {
    document.removeEventListener('click', this.documentClick);
  }

  // setDate = (date, isDayView = false) => {
  setDate(date, isDayView = false) {
    if (this.checkIfDateDisabled(date)) return;

    this.setState({
      date,
      inputValue: date.format(this.state.format),
      isVisible:
      this.state.closeOnSelect && isDayView ? !this.state.isVisible : this.state.isVisible,
    });

    const computableDate = date.format(this.state.computableFormat);

    if (this.props.onChange) {
      this.props.onChange(computableDate);
    }

    if (this.props.input) {
      this.props.input.onChange(computableDate);
    }
  }

  setVisibility(val) {
    const value = val !== undefined ? val : !this.state.isVisible;
    const eventMethod = value ? 'addEventListener' : 'removeEventListener';

    document[eventMethod]('keydown', this.keyDown);

    if (this.state.isVisible !== value && !this.props.disabled) {
      this.setState({ isVisible: value });
    }
  }

  getView() {
    const calendarDate = this.state.date || moment();
    const { maxDate, minDate } = this.state;
    const props = {
      date: calendarDate,
      nextView: this.nextView,
      setDate: this.setDate,
      prevView: this.prevView,
      maxDate,
      minDate,
    };

    switch (this.state.currentView) {
      case 0:
        return <DayViews {...props} />;
      case 1:
        return <MonthView {...props} />;
      case 2:
        return <YearView {...props} />;
      default:
        return <DayViews {...props} />;
    }
  }

  // カレンダー外のクリックイベント
  // documentClick = () => {
  documentClick() {
    this.closeCalendar();
  }

  // カレンダーのクローズアイコンクリックイベント
  // closeClick = () => {
  closeClick() {
    this.closeCalendar();
  }

  // テキストボックスにフォーカスする
  // focusDateInput = () => {
  focusDateInput() {
    if (this.dateInput) {
      this.dateInput.focus();
    }
  }

  // inputBlur = () => {
  inputBlur() {
    let newDate = null;
    let computableDate = null;

    // 入力値（数字3文字、数字5文字、最初のスラッシュまでの文字が数字1文字の場合は左端に0をつける）
    // MDD、YMMDD、Y/MM/DD への対応
    const prefixZero = this.state.inputValue && this.state.inputValue.match(/^\d{3}$|^\d{5}$|^\d\/.+$/) ? '0' : '';
    const date = this.state.inputValue ? prefixZero + this.state.inputValue : this.state.inputValue;
    const { format } = this.state;

    // 日付の書式
    const parsingFormat = ['YYYY/M/D', 'YY/M/D', 'M/D', 'YYYYMMDD', 'YYMMDD', 'MMDD', 'D'];

    if (date) {
      // 書式に従って日付を取得
      newDate = moment(date, parsingFormat, true);
    }

    // 入力必須で空欄か、もしくは入力が書式に合わなければ変更前の値をセット
    if ((!newDate && this.props.required) || (newDate && !newDate.isValid())) {
      newDate = moment(this.state.prevdate, parsingFormat, true);

      // 変更前の値も書式に合わなければ初期値をセット
      if (!newDate.isValid()) {
        newDate = this.state.defaultDate;
      }
    }
    computableDate = newDate && newDate.isValid() ? newDate.format(this.state.computableFormat) : null;

    this.setState({
      date: newDate,
      inputValue: newDate ? newDate.format(format) : undefined,
    });

    if (this.props.onChange) {
      this.props.onChange(computableDate);
    }

    if (this.props.input) {
      this.props.input.onChange(computableDate);
    }
  }

  // テキストボックスにフォーカスを当てる
  // inputFocus = (e) => {
  inputFocus(e) {
    if (this.props.openOnInputFocus) {
      this.toggleClick();
    }
    if (this.props.onFocus) {
      this.props.onFocus(e);
    }
    // 前回値を保持
    this.setState({
      prevdate: this.props.value,
    });
  }

  // キーを押したとき
  // keyDown = (e) => {
  keyDown(e) {
    Util.keyDownActions.call(this, e.keyCode);
  }

  // extView = () => {
  nextView() {
    if (this.checkIfDateDisabled(this.state.date)) return;
    this.setState({ currentView: this.state.currentView + 1 });
  }

  // prevView = (date) => {
  prevView(date) {
    let newDate = date;
    if (this.state.minDate && date.isBefore(this.state.minDate, 'day')) {
      newDate = this.state.minDate.clone();
    }

    if (this.state.maxDate && date.isAfter(this.state.maxDate, 'day')) {
      newDate = this.state.maxDate.clone();
    }

    if (this.state.currentView === this.state.minView) {
      this.setState({
        date: newDate,
        inputValue: date.format(this.state.format),
        isVisible: false,
      });
      const computableDate = date.format(this.state.computableFormat);
      if (this.props.onChange) {
        this.props.onChange(computableDate);
      }
      if (this.props.input) {
        this.props.input.onChange(computableDate);
      }
    } else {
      this.setState({
        date,
        currentView: this.state.currentView - 1,
      });
    }
  }

  // todayClick = () => {
  todayClick() {
    const today = moment().startOf('day');

    if (this.checkIfDateDisabled(today)) return;

    this.setState({
      date: today,
      inputValue: today.format(this.state.format),
      currentView: this.state.minView,
      isVisible: this.state.closeOnSelect ? !this.state.isVisible : this.state.isVisible,
    });

    const computableToday = today.format(this.state.computableFormat);

    if (this.props.onChange) {
      this.props.onChange(computableToday);
    }

    if (this.props.input) {
      this.props.input.onChange(computableToday);
    }
  }

  // toggleClick = () => {
  toggleClick() {
    this.setState({ isCalendar: true });
    this.setVisibility();
  }

  // calendarClick = () => {
  calendarClick() {
    this.setState({ isCalendar: true });
  }

  // changeDate = (e) => {
  changeDate(e) {
    //eslint-disable-line
    this.setState({ inputValue: e.target.value });
  }

  checkIfDateDisabled(date) {
    return (
      (date && this.state.minDate && date.isBefore(this.state.minDate, 'day')) ||
      (date && this.state.maxDate && date.isAfter(this.state.maxDate, 'day'))
    );
  }

  // カレンダーを閉じる
  closeCalendar() {
    if (!this.state.isCalendar) {
      this.setVisibility(false);
    }
    this.setState({ isCalendar: false });
  }

  render() {
    const view = this.getView();
    const calendarClass = classNames({
      [styles.inputCalendarWrapper]: true,
      [styles.iconHidden]: this.props.hideIcon,
    });
    const calendar =
      !this.state.isVisible || this.props.disabled ? (
        ''
      ) : (
        <Draggable>
          <div role="presentation" className={calendarClass} onClick={this.calendarClick}>
            <div role="presentation" tabIndex="-1" className={classNames(styles.icon, styles.iconClose)} onClick={this.closeClick}>
              <svg width="8" height="8" viewBox="0 0 21.9 21.9">
                <path d="M14.1,11.3c-0.2-0.2-0.2-0.5,0-0.7l7.5-7.5c0.2-0.2,0.3-0.5,0.3-0.7s-0.1-0.5-0.3-0.7l-1.4-1.4C20,0.1,19.7,0,19.5,0
                  c-0.3,0-0.5,0.1-0.7,0.3l-7.5,7.5c-0.2,0.2-0.5,0.2-0.7,0L3.1,0.3C2.9,0.1,2.6,0,2.4,0S1.9,0.1,1.7,0.3L0.3,1.7C0.1,1.9,0,2.2,0,2.4
                  s0.1,0.5,0.3,0.7l7.5,7.5c0.2,0.2,0.2,0.5,0,0.7l-7.5,7.5C0.1,19,0,19.3,0,19.5s0.1,0.5,0.3,0.7l1.4,1.4c0.2,0.2,0.5,0.3,0.7,0.3
                  s0.5-0.1,0.7-0.3l7.5-7.5c0.2-0.2,0.5-0.2,0.7,0l7.5,7.5c0.2,0.2,0.5,0.3,0.7,0.3s0.5-0.1,0.7-0.3l1.4-1.4c0.2-0.2,0.3-0.5,0.3-0.7
                  s-0.1-0.5-0.3-0.7L14.1,11.3z"
                />
              </svg>
            </div>
            {view}
            <span
              role="presentation"
              tabIndex="-1"
              className={classNames(styles.todayBtn, { [styles.disabled]: this.checkIfDateDisabled(moment().startOf('day')) })}
              onClick={this.todayClick}
            >
              本日を指定
            </span>
          </div>
        </Draggable>
      );
    const readOnly = Util.checkForMobile(this.props.hideTouchKeyboard);
    const calendarIcon = getIcon(this.props, this.toggleClick);
    const inputClass = this.props.inputFieldClass || styles.inputCalendarField;
    return (
      <div className={classNames(styles.inputCalendar, styles.calendarOverAll)}>
        <input
          name={this.props.inputName}
          className={inputClass}
          id={this.props.inputFieldId}
          onBlur={this.inputBlur}
          onChange={this.changeDate}
          onFocus={this.inputFocus}
          placeholder={this.props.placeholder}
          readOnly={readOnly}
          disabled={this.props.disabled}
          type="text"
          ref={(input) => {
            this.dateInput = input;
          }}
          value={this.state.inputValue || ''}
        />
        {calendarIcon}
        {calendar}
      </div>
    );
  }
}

DatePicker.propTypes = {
  closeOnSelect: PropTypes.bool,
  value: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.instanceOf(moment),
    PropTypes.instanceOf(Date),
  ]),
  minDate: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.instanceOf(moment),
    PropTypes.instanceOf(Date),
  ]),
  maxDate: PropTypes.oneOfType([
    PropTypes.string,
    PropTypes.instanceOf(moment),
    PropTypes.instanceOf(Date),
  ]),
  format: PropTypes.string,
  inputName: PropTypes.string, // テキストボックスのname
  inputFieldId: PropTypes.string, // テキストボックスのid
  inputFieldClass: PropTypes.string, // テキストボックスのclass
  onChange: PropTypes.func,
  onFocus: PropTypes.func,
  openOnInputFocus: PropTypes.bool,
  placeholder: PropTypes.string,
  hideTouchKeyboard: PropTypes.bool,
  hideIcon: PropTypes.bool,
  customIcon: PropTypes.string,
  disabled: PropTypes.bool,
  focused: PropTypes.bool,
  required: PropTypes.bool, // 必須項目かどうか
  input: PropTypes.shape({
    value: PropTypes.oneOfType([
      PropTypes.string,
      PropTypes.instanceOf(moment),
      PropTypes.instanceOf(Date),
    ]),
    onChange: PropTypes.func,
  }),
};

DatePicker.defaultProps = {
  closeOnSelect: true,
  value: null,
  minDate: null,
  maxDate: null,
  format: 'YYYY/MM/DD',
  inputName: null, // テキストボックスのname
  inputFieldId: null, // テキストボックスのid
  inputFieldClass: null, // テキストボックスのclass
  onChange: null,
  onFocus: null,
  openOnInputFocus: false,
  placeholder: null,
  hideTouchKeyboard: false,
  hideIcon: false,
  customIcon: null,
  disabled: false,
  focused: false,
  required: false, // 必須項目かどうか
  input: null,
};

export default DatePicker;
